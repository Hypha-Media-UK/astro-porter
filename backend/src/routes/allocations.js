const express = require('express');
const { PrismaClient } = require('@prisma/client');
const { z } = require('zod');

const router = express.Router();
const prisma = new PrismaClient();

// Validation schemas
const createAllocationSchema = z.object({
  porter_id: z.string(),
  department_id: z.string(),
  service_id: z.string().optional(),
  start_datetime: z.string(),
  end_datetime: z.string().optional(),
  type: z.enum(['REGULAR', 'TEMPORARY', 'RELIEF']),
  reason: z.string().optional()
});

const updateAllocationSchema = z.object({
  porter_id: z.string().optional(),
  department_id: z.string().optional(),
  service_id: z.string().optional(),
  start_datetime: z.string().optional(),
  end_datetime: z.string().optional(),
  type: z.enum(['REGULAR', 'TEMPORARY', 'RELIEF']).optional(),
  reason: z.string().optional()
});

// Get all allocations
router.get('/', async (req, res) => {
  try {
    const { porter_id, department_id, service_id, type, active_only } = req.query;
    
    const where = {};
    if (porter_id) where.porterId = porter_id;
    if (department_id) where.departmentId = department_id;
    if (service_id) where.serviceId = service_id;
    if (type) where.type = type;
    
    // Filter for active allocations only
    if (active_only === 'true') {
      const now = new Date();
      where.startDatetime = { lte: now };
      where.OR = [
        { endDatetime: null },
        { endDatetime: { gte: now } }
      ];
    }

    const allocations = await prisma.allocation.findMany({
      where,
      include: {
        porter: {
          select: { id: true, name: true, contractType: true, porterType: true }
        },
        department: {
          select: { id: true, name: true, building: { select: { name: true } } }
        },
        service: {
          select: { id: true, name: true, description: true }
        }
      },
      orderBy: { startDatetime: 'desc' }
    });

    res.json({ success: true, data: allocations });
  } catch (error) {
    console.error('Error fetching allocations:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch allocations' });
  }
});

// Get specific allocation
router.get('/:id', async (req, res) => {
  try {
    const allocation = await prisma.allocation.findUnique({
      where: { id: req.params.id },
      include: {
        porter: {
          select: { id: true, name: true, contractType: true, porterType: true }
        },
        department: {
          select: { id: true, name: true, building: { select: { name: true } } }
        },
        service: {
          select: { id: true, name: true, description: true }
        }
      }
    });

    if (!allocation) {
      return res.status(404).json({ success: false, error: 'Allocation not found' });
    }

    res.json({ success: true, data: allocation });
  } catch (error) {
    console.error('Error fetching allocation:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch allocation' });
  }
});

// Create allocation
router.post('/', async (req, res) => {
  try {
    const validatedData = createAllocationSchema.parse(req.body);

    // Check for conflicting allocations
    const conflictingAllocation = await prisma.allocation.findFirst({
      where: {
        porterId: validatedData.porter_id,
        startDatetime: { lte: new Date(validatedData.start_datetime) },
        OR: [
          { endDatetime: null },
          { endDatetime: { gte: new Date(validatedData.start_datetime) } }
        ]
      }
    });

    if (conflictingAllocation && validatedData.type !== 'TEMPORARY') {
      return res.status(400).json({ 
        success: false, 
        error: 'Porter already has an active allocation during this period' 
      });
    }

    const allocation = await prisma.allocation.create({
      data: {
        porterId: validatedData.porter_id,
        departmentId: validatedData.department_id,
        serviceId: validatedData.service_id || null,
        startDatetime: new Date(validatedData.start_datetime),
        endDatetime: validatedData.end_datetime ? new Date(validatedData.end_datetime) : null,
        type: validatedData.type,
        reason: validatedData.reason
      },
      include: {
        porter: {
          select: { id: true, name: true, contractType: true, porterType: true }
        },
        department: {
          select: { id: true, name: true, building: { select: { name: true } } }
        },
        service: {
          select: { id: true, name: true, description: true }
        }
      }
    });

    res.status(201).json({ success: true, data: allocation });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ success: false, error: 'Invalid input', details: error.errors });
    }
    console.error('Error creating allocation:', error);
    res.status(500).json({ success: false, error: 'Failed to create allocation' });
  }
});

// Update allocation
router.put('/:id', async (req, res) => {
  try {
    const validatedData = updateAllocationSchema.parse(req.body);

    const updateData = {};
    if (validatedData.porter_id) updateData.porterId = validatedData.porter_id;
    if (validatedData.department_id) updateData.departmentId = validatedData.department_id;
    if (validatedData.service_id !== undefined) updateData.serviceId = validatedData.service_id || null;
    if (validatedData.start_datetime) updateData.startDatetime = new Date(validatedData.start_datetime);
    if (validatedData.end_datetime !== undefined) {
      updateData.endDatetime = validatedData.end_datetime ? new Date(validatedData.end_datetime) : null;
    }
    if (validatedData.type) updateData.type = validatedData.type;
    if (validatedData.reason !== undefined) updateData.reason = validatedData.reason;

    const allocation = await prisma.allocation.update({
      where: { id: req.params.id },
      data: updateData,
      include: {
        porter: {
          select: { id: true, name: true, contractType: true, porterType: true }
        },
        department: {
          select: { id: true, name: true, building: { select: { name: true } } }
        },
        service: {
          select: { id: true, name: true, description: true }
        }
      }
    });

    res.json({ success: true, data: allocation });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ success: false, error: 'Invalid input', details: error.errors });
    }
    console.error('Error updating allocation:', error);
    res.status(500).json({ success: false, error: 'Failed to update allocation' });
  }
});

// Delete allocation
router.delete('/:id', async (req, res) => {
  try {
    await prisma.allocation.delete({
      where: { id: req.params.id }
    });

    res.json({ success: true, message: 'Allocation deleted successfully' });
  } catch (error) {
    console.error('Error deleting allocation:', error);
    res.status(500).json({ success: false, error: 'Failed to delete allocation' });
  }
});

// Get porter's current allocation
router.get('/porter/:porterId/current', async (req, res) => {
  try {
    const now = new Date();
    
    const allocation = await prisma.allocation.findFirst({
      where: {
        porterId: req.params.porterId,
        startDatetime: { lte: now },
        OR: [
          { endDatetime: null },
          { endDatetime: { gte: now } }
        ]
      },
      include: {
        department: {
          select: { id: true, name: true, building: { select: { name: true } } }
        },
        service: {
          select: { id: true, name: true, description: true }
        }
      },
      orderBy: [
        { type: 'desc' }, // TEMPORARY allocations override others
        { startDatetime: 'desc' }
      ]
    });

    res.json({ success: true, data: allocation });
  } catch (error) {
    console.error('Error fetching current allocation:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch current allocation' });
  }
});

// Get department's current allocations
router.get('/department/:departmentId/current', async (req, res) => {
  try {
    const now = new Date();
    
    const allocations = await prisma.allocation.findMany({
      where: {
        departmentId: req.params.departmentId,
        startDatetime: { lte: now },
        OR: [
          { endDatetime: null },
          { endDatetime: { gte: now } }
        ]
      },
      include: {
        porter: {
          select: { id: true, name: true, contractType: true, porterType: true }
        },
        service: {
          select: { id: true, name: true, description: true }
        }
      },
      orderBy: { startDatetime: 'desc' }
    });

    res.json({ success: true, data: allocations });
  } catch (error) {
    console.error('Error fetching department allocations:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch department allocations' });
  }
});

module.exports = router;
