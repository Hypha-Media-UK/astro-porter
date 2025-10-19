const express = require('express');
const { PrismaClient } = require('@prisma/client');
const { z } = require('zod');

const router = express.Router();
const prisma = new PrismaClient();

// Validation schemas
const createShiftSchema = z.object({
  name: z.string().min(1).max(255),
  description: z.string().optional(),
  pattern: z.array(z.object({
    type: z.string(),
    label: z.string(),
    duration_days: z.number().int().positive()
  })),
  ground_zero_date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/),
  offset_days: z.number().int().min(0).default(0)
});

const updateShiftSchema = z.object({
  name: z.string().min(1).max(255).optional(),
  description: z.string().optional(),
  pattern: z.array(z.object({
    type: z.string(),
    label: z.string(),
    duration_days: z.number().int().positive()
  })).optional(),
  ground_zero_date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).optional(),
  offset_days: z.number().int().min(0).optional()
});

// GET /api/shifts - List all shifts
router.get('/', async (req, res) => {
  try {
    const shifts = await prisma.shift.findMany({
      orderBy: {
        name: 'asc'
      }
    });

    res.json({
      success: true,
      data: shifts
    });
  } catch (error) {
    console.error('Error fetching shifts:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch shifts'
    });
  }
});

// GET /api/shifts/:id - Get a specific shift
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    const shift = await prisma.shift.findUnique({
      where: { id: id },
      include: {
        porters: true
      }
    });

    if (!shift) {
      return res.status(404).json({
        success: false,
        error: 'Shift not found'
      });
    }

    res.json({
      success: true,
      data: shift
    });
  } catch (error) {
    console.error('Error fetching shift:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch shift'
    });
  }
});

// POST /api/shifts - Create a new shift
router.post('/', async (req, res) => {
  try {
    const validatedData = createShiftSchema.parse(req.body);
    
    const shift = await prisma.shift.create({
      data: {
        name: validatedData.name,
        description: validatedData.description,
        pattern: validatedData.pattern,
        groundZeroDate: new Date(validatedData.ground_zero_date),
        offsetDays: validatedData.offset_days
      }
    });

    res.status(201).json({
      success: true,
      data: shift
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({
        success: false,
        error: 'Validation error',
        details: error.errors
      });
    }

    console.error('Error creating shift:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to create shift'
    });
  }
});

// PUT /api/shifts/:id - Update a shift
router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const validatedData = updateShiftSchema.parse(req.body);
    
    // Map API fields to Prisma model fields
    const updateData = {}
    if (validatedData.name) updateData.name = validatedData.name
    if (validatedData.description !== undefined) updateData.description = validatedData.description
    if (validatedData.pattern) updateData.pattern = validatedData.pattern
    if (validatedData.ground_zero_date) updateData.groundZeroDate = new Date(validatedData.ground_zero_date)
    if (validatedData.offset_days !== undefined) updateData.offsetDays = validatedData.offset_days
    
    const shift = await prisma.shift.update({
      where: { id: id },
      data: updateData
    });

    res.json({
      success: true,
      data: shift
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
        error: 'Shift not found'
      });
    }

    console.error('Error updating shift:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to update shift'
    });
  }
});

// DELETE /api/shifts/:id - Delete a shift
router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    await prisma.shift.delete({
      where: { id: id }
    });

    res.json({
      success: true,
      message: 'Shift deleted successfully'
    });
  } catch (error) {
    if (error.code === 'P2025') {
      return res.status(404).json({
        success: false,
        error: 'Shift not found'
      });
    }

    if (error.code === 'P2003') {
      return res.status(400).json({
        success: false,
        error: 'Cannot delete shift: it is referenced by other records'
      });
    }

    console.error('Error deleting shift:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to delete shift'
    });
  }
});

module.exports = router;
