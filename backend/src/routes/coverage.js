const express = require('express');
const { PrismaClient } = require('@prisma/client');
const { z } = require('zod');

const router = express.Router();
const prisma = new PrismaClient();

// Get coverage status for all departments
router.get('/departments', async (req, res) => {
  try {
    const targetDate = new Date(req.query.date || new Date());
    const targetHour = parseInt(req.query.hour) || new Date().getHours();

    const departments = await prisma.department.findMany({
      include: {
        building: true,
        services: true,
        porters: {
          where: {
            countsTowardsStaffing: true
          },
          include: {
            shift: {
              include: {
                pattern: true
              }
            }
          }
        }
      }
    });

    const coverageData = await Promise.all(
      departments.map(async (department) => {
        const coverage = await calculateDepartmentCoverage(department, targetDate, targetHour);
        return {
          id: department.id,
          name: department.name,
          building: department.building.name,
          is247: department.is247,
          ...coverage
        };
      })
    );

    res.json({ success: true, data: coverageData });
  } catch (error) {
    console.error('Error calculating coverage:', error);
    res.status(500).json({ success: false, error: 'Failed to calculate coverage' });
  }
});

// Get detailed coverage for a specific department
router.get('/departments/:id', async (req, res) => {
  try {
    const departmentId = req.params.id;
    const targetDate = new Date(req.query.date || new Date());
    const targetHour = parseInt(req.query.hour) || new Date().getHours();

    const department = await prisma.department.findUnique({
      where: { id: departmentId },
      include: {
        building: true,
        services: true,
        porters: {
          where: {
            countsTowardsStaffing: true
          },
          include: {
            shift: {
              include: {
                pattern: true
              }
            }
          }
        }
      }
    });

    if (!department) {
      return res.status(404).json({ success: false, error: 'Department not found' });
    }

    const coverage = await calculateDepartmentCoverage(department, targetDate, targetHour);
    const porterDetails = await getPorterDetails(department, targetDate, targetHour);

    res.json({ 
      success: true, 
      data: {
        department: {
          id: department.id,
          name: department.name,
          building: department.building.name,
          is247: department.is247
        },
        coverage,
        porters: porterDetails
      }
    });
  } catch (error) {
    console.error('Error calculating department coverage:', error);
    res.status(500).json({ success: false, error: 'Failed to calculate department coverage' });
  }
});

// Coverage calculation helper functions
async function calculateDepartmentCoverage(department, targetDate, targetHour) {
  // Determine if department should be operational at this time
  const isOperational = isDepartmentOperational(department, targetDate, targetHour);
  
  if (!isOperational) {
    return {
      required: 0,
      available: 0,
      shortfall: 0,
      status: 'closed',
      operational: false
    };
  }

  // Calculate required porters (simplified - could be enhanced with service-specific requirements)
  const requiredPorters = calculateRequiredPorters(department, targetHour);
  
  // Get available porters
  const availablePorters = await getAvailablePorters(department, targetDate, targetHour);
  
  const shortfall = Math.max(0, requiredPorters - availablePorters.length);
  const status = getStatusColor(requiredPorters, availablePorters.length);

  return {
    required: requiredPorters,
    available: availablePorters.length,
    shortfall,
    status,
    operational: true,
    availablePorters: availablePorters // Include porter details for frontend
  };
}

function isDepartmentOperational(department, targetDate, targetHour) {
  if (department.is247) {
    return true;
  }
  
  // For non-24/7 departments, assume operational 08:00-20:00
  // This could be enhanced with actual schedule data
  return targetHour >= 8 && targetHour < 20;
}

function calculateRequiredPorters(department, targetHour) {
  // Simplified calculation - could be enhanced with service-specific requirements
  if (department.is247) {
    // 24/7 departments need more coverage during day shifts
    return targetHour >= 8 && targetHour < 20 ? 3 : 2;
  } else {
    // Regular departments need standard coverage during operational hours
    return 2;
  }
}

async function getAvailablePorters(department, targetDate, targetHour) {
  try {
    const targetDateTime = new Date(targetDate);
    targetDateTime.setHours(targetHour, 0, 0, 0);

    // Get all porters assigned to this department with full details
    const porters = await prisma.porter.findMany({
      where: {
        OR: [
          { regularDepartmentId: department.id },
          {
            allocations: {
              some: {
                departmentId: department.id,
                startDatetime: { lte: targetDateTime },
                OR: [
                  { endDatetime: null },
                  { endDatetime: { gte: targetDateTime } }
                ]
              }
            }
          }
        ]
      },
      include: {
        shift: {
          include: {
            pattern: true
          }
        },
        allocations: {
          where: {
            departmentId: department.id,
            startDatetime: { lte: targetDateTime },
            OR: [
              { endDatetime: null },
              { endDatetime: { gte: targetDateTime } }
            ]
          }
        },
        availability: {
          where: {
            startDatetime: { lte: targetDateTime },
            endDatetime: { gte: targetDateTime }
          }
        },
        porterCapabilities: {
          include: {
            capability: true
          }
        }
      }
    });

    const availablePorters = [];

    for (const porter of porters) {
      // Check if porter is on duty according to shift pattern
      const isOnDuty = await isPorterOnDuty(porter, targetDate, targetHour);
      if (!isOnDuty) {
        continue;
      }

      // Check availability status - exclude if unavailable
      const unavailableRecord = porter.availability.find(avail =>
        avail.status === 'UNAVAILABLE'
      );

      if (unavailableRecord) {
        continue; // Porter is unavailable (sick, leave, etc.)
      }

      // Check if porter has required capabilities for this department
      const hasRequiredCapabilities = await checkPorterCapabilities(porter, department);
      if (!hasRequiredCapabilities) {
        continue; // Porter lacks required capabilities
      }

      availablePorters.push({
        ...porter,
        availabilityStatus: porter.availability.length > 0 ? porter.availability[0].status : 'AVAILABLE',
        capabilityMatch: hasRequiredCapabilities
      });
    }

    return availablePorters;
  } catch (error) {
    console.error('Error getting available porters:', error);
    return [];
  }
}

// Check if porter has required capabilities for department
async function checkPorterCapabilities(porter, department) {
  try {
    // Get required capabilities for this department
    const requiredCapabilities = await prisma.departmentCapability.findMany({
      where: {
        departmentId: department.id,
        requiredLevel: 'REQUIRED'
      },
      include: {
        capability: true
      }
    });

    // If no required capabilities, porter is qualified
    if (requiredCapabilities.length === 0) {
      return true;
    }

    // Check if porter has all required capabilities
    const porterCapabilityIds = porter.porterCapabilities.map(pc => pc.capabilityId);

    for (const reqCap of requiredCapabilities) {
      if (!porterCapabilityIds.includes(reqCap.capabilityId)) {
        return false; // Missing required capability
      }

      // Check if capability is expired
      const porterCap = porter.porterCapabilities.find(pc => pc.capabilityId === reqCap.capabilityId);
      if (porterCap.expiryDate && porterCap.expiryDate < new Date()) {
        // For now, allow expired capabilities with warning (configurable via settings)
        console.warn(`Porter ${porter.name} has expired capability: ${reqCap.capability.name}`);
      }
    }

    return true;
  } catch (error) {
    console.error('Error checking porter capabilities:', error);
    return false; // Fail safe - if we can't check, assume not qualified
  }
}

async function isPorterOnDuty(porter, targetDate, targetHour) {
  if (!porter.shift || !porter.shift.pattern) {
    return false;
  }

  try {
    const pattern = JSON.parse(porter.shift.pattern.patternJson);
    const shiftState = getCurrentShiftState(pattern, targetDate);
    
    // Check if porter is on duty during this shift state
    return shiftState.type === 'ON';
  } catch (error) {
    console.error('Error parsing shift pattern:', error);
    return false;
  }
}

function getCurrentShiftState(pattern, targetDate) {
  // Simplified shift calculation - assumes ground zero of 2024-01-01
  const groundZero = new Date('2024-01-01');
  const daysSinceGroundZero = Math.floor((targetDate - groundZero) / (1000 * 60 * 60 * 24));
  
  // Calculate total pattern duration
  const totalDays = pattern.reduce((sum, segment) => sum + segment.duration_days, 0);
  
  // Find current position in pattern
  const cyclePosition = daysSinceGroundZero % totalDays;
  
  let currentDay = 0;
  for (const segment of pattern) {
    if (cyclePosition >= currentDay && cyclePosition < currentDay + segment.duration_days) {
      return segment;
    }
    currentDay += segment.duration_days;
  }
  
  return pattern[0]; // Fallback
}

function getStatusColor(required, available) {
  if (available >= required) {
    return 'good';
  } else if (available >= required * 0.75) {
    return 'warning';
  } else {
    return 'critical';
  }
}

async function getPorterDetails(department, targetDate, targetHour) {
  const porters = department.porters || [];
  
  const porterDetails = await Promise.all(
    porters.map(async (porter) => {
      const isOnDuty = await isPorterOnDuty(porter, targetDate, targetHour);
      const shiftState = porter.shift && porter.shift.pattern ? 
        getCurrentShiftState(JSON.parse(porter.shift.pattern.patternJson), targetDate) : 
        null;
      
      return {
        id: porter.id,
        name: porter.name,
        contractType: porter.contractType,
        porterType: porter.porterType,
        isOnDuty,
        shiftState: shiftState ? `${shiftState.label} (${shiftState.type})` : 'No shift assigned'
      };
    })
  );
  
  return porterDetails;
}

module.exports = router;
