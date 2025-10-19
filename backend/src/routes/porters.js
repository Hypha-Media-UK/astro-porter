const express = require('express');
const { PrismaClient } = require('@prisma/client');
const { z } = require('zod');

const router = express.Router();
const prisma = new PrismaClient();

// Validation schemas
const createPorterSchema = z.object({
  name: z.string().min(1).max(255),
  contract_type: z.enum(['SHIFT', 'FIXED', 'RELIEF']),
  porter_type: z.enum(['PORTER', 'SUPERVISOR']).default('PORTER'),
  regular_department_id: z.string().min(1).optional(),
  shift_id: z.string().min(1).optional(),
  weekly_min_hours: z.number().min(0).optional(),
  contracted_hours: z.number().min(0).optional(),
  counts_towards_staffing: z.boolean().default(true)
});

const updatePorterSchema = z.object({
  name: z.string().min(1).max(255).optional(),
  contract_type: z.enum(['SHIFT', 'FIXED', 'RELIEF']).optional(),
  porter_type: z.enum(['PORTER', 'SUPERVISOR']).optional(),
  regular_department_id: z.string().min(1).optional(),
  shift_id: z.string().min(1).optional(),
  weekly_min_hours: z.number().min(0).optional(),
  contracted_hours: z.number().min(0).optional(),
  counts_towards_staffing: z.boolean().optional()
});

// GET /api/porters - List all porters
router.get('/', async (req, res) => {
  try {
    const { active_only } = req.query;
    
    const porters = await prisma.porter.findMany({
      include: {
        shift: true,
        regularDepartment: {
          include: {
            building: true
          }
        }
      },
      orderBy: {
        name: 'asc'
      }
    });

    res.json({
      success: true,
      data: porters
    });
  } catch (error) {
    console.error('Error fetching porters:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch porters'
    });
  }
});

// GET /api/porters/:id - Get a specific porter
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    const porter = await prisma.porter.findUnique({
      where: { id: id },
      include: {
        shift: true,
        regularDepartment: {
          include: {
            building: true
          }
        }
      }
    });

    if (!porter) {
      return res.status(404).json({
        success: false,
        error: 'Porter not found'
      });
    }

    res.json({
      success: true,
      data: porter
    });
  } catch (error) {
    console.error('Error fetching porter:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch porter'
    });
  }
});

// POST /api/porters - Create a new porter
router.post('/', async (req, res) => {
  try {
    const validatedData = createPorterSchema.parse(req.body);

    // Check if shift exists (if provided)
    if (validatedData.shift_id) {
      const shift = await prisma.shift.findUnique({
        where: { id: validatedData.shift_id }
      });

      if (!shift) {
        return res.status(400).json({
          success: false,
          error: 'Shift not found'
        });
      }
    }

    // Check if department exists (if provided)
    if (validatedData.regular_department_id) {
      const department = await prisma.department.findUnique({
        where: { id: validatedData.regular_department_id }
      });

      if (!department) {
        return res.status(400).json({
          success: false,
          error: 'Department not found'
        });
      }
    }

    const porter = await prisma.porter.create({
      data: {
        name: validatedData.name,
        contractType: validatedData.contract_type,
        porterType: validatedData.porter_type,
        shiftId: validatedData.shift_id,
        regularDepartmentId: validatedData.regular_department_id,
        weeklyMinHours: validatedData.weekly_min_hours,
        contractedHours: validatedData.contracted_hours,
        countsTowardsStaffing: validatedData.counts_towards_staffing
      },
      include: {
        shift: true,
        regularDepartment: {
          include: {
            building: true
          }
        }
      }
    });

    res.status(201).json({
      success: true,
      data: porter
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({
        success: false,
        error: 'Validation error',
        details: error.errors
      });
    }

    console.error('Error creating porter:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to create porter'
    });
  }
});

// PUT /api/porters/:id - Update a porter
router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const validatedData = updatePorterSchema.parse(req.body);

    // Check if shift exists (if being updated)
    if (validatedData.shift_id) {
      const shift = await prisma.shift.findUnique({
        where: { id: validatedData.shift_id }
      });

      if (!shift) {
        return res.status(400).json({
          success: false,
          error: 'Shift not found'
        });
      }
    }

    // Check if department exists (if being updated)
    if (validatedData.regular_department_id) {
      const department = await prisma.department.findUnique({
        where: { id: validatedData.regular_department_id }
      });

      if (!department) {
        return res.status(400).json({
          success: false,
          error: 'Department not found'
        });
      }
    }

    // Map API fields to Prisma model fields
    const updateData = {}
    if (validatedData.name) updateData.name = validatedData.name
    if (validatedData.contract_type) updateData.contractType = validatedData.contract_type
    if (validatedData.porter_type) updateData.porterType = validatedData.porter_type
    if (validatedData.shift_id !== undefined) updateData.shiftId = validatedData.shift_id
    if (validatedData.regular_department_id !== undefined) updateData.regularDepartmentId = validatedData.regular_department_id
    if (validatedData.weekly_min_hours !== undefined) updateData.weeklyMinHours = validatedData.weekly_min_hours
    if (validatedData.contracted_hours !== undefined) updateData.contractedHours = validatedData.contracted_hours
    if (validatedData.counts_towards_staffing !== undefined) updateData.countsTowardsStaffing = validatedData.counts_towards_staffing

    const porter = await prisma.porter.update({
      where: { id: id },
      data: updateData,
      include: {
        shift: true,
        regularDepartment: {
          include: {
            building: true
          }
        }
      }
    });

    res.json({
      success: true,
      data: porter
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({
        success: false,
        error: 'Validation error',
        details: error.errors
      });
    }

    if (error.code === 'P2025') {
      return res.status(404).json({
        success: false,
        error: 'Porter not found'
      });
    }

    console.error('Error updating porter:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to update porter'
    });
  }
});

// DELETE /api/porters/:id - Delete a porter
router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    await prisma.porter.delete({
      where: { id: id }
    });

    res.json({
      success: true,
      message: 'Porter deleted successfully'
    });
  } catch (error) {
    if (error.code === 'P2025') {
      return res.status(404).json({
        success: false,
        error: 'Porter not found'
      });
    }

    if (error.code === 'P2003') {
      return res.status(400).json({
        success: false,
        error: 'Cannot delete porter with existing allocations'
      });
    }

    console.error('Error deleting porter:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to delete porter'
    });
  }
});

module.exports = router;
