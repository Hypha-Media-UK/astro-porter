const express = require('express');
const { PrismaClient } = require('@prisma/client');
const { z } = require('zod');

const router = express.Router();
const prisma = new PrismaClient();

// Validation schemas
const createShiftPatternSchema = z.object({
  name: z.string().min(1).max(255),
  description: z.string().optional(),
  pattern: z.array(z.object({
    type: z.string(),
    label: z.string(),
    duration_days: z.number().int().positive()
  }))
});

const updateShiftPatternSchema = z.object({
  name: z.string().min(1).max(255).optional(),
  description: z.string().optional(),
  pattern: z.array(z.object({
    type: z.string(),
    label: z.string(),
    duration_days: z.number().int().positive()
  })).optional()
});

// GET /api/shift-patterns - List all shift patterns
router.get('/', async (req, res) => {
  try {
    const shiftPatterns = await prisma.shiftPattern.findMany({
      orderBy: {
        name: 'asc'
      }
    });

    res.json({
      success: true,
      data: shiftPatterns
    });
  } catch (error) {
    console.error('Error fetching shift patterns:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch shift patterns'
    });
  }
});

// GET /api/shift-patterns/:id - Get a specific shift pattern
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    const shiftPattern = await prisma.shiftPattern.findUnique({
      where: { id: id },
      include: {
        shifts: true
      }
    });

    if (!shiftPattern) {
      return res.status(404).json({
        success: false,
        error: 'Shift pattern not found'
      });
    }

    res.json({
      success: true,
      data: shiftPattern
    });
  } catch (error) {
    console.error('Error fetching shift pattern:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch shift pattern'
    });
  }
});

// POST /api/shift-patterns - Create a new shift pattern
router.post('/', async (req, res) => {
  try {
    const validatedData = createShiftPatternSchema.parse(req.body);
    
    const shiftPattern = await prisma.shiftPattern.create({
      data: {
        name: validatedData.name,
        description: validatedData.description,
        patternJson: JSON.stringify(validatedData.pattern)
      }
    });

    res.status(201).json({
      success: true,
      data: shiftPattern
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({
        success: false,
        error: 'Validation error',
        details: error.errors
      });
    }

    console.error('Error creating shift pattern:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to create shift pattern'
    });
  }
});

// PUT /api/shift-patterns/:id - Update a shift pattern
router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const validatedData = updateShiftPatternSchema.parse(req.body);
    
    // Map API fields to Prisma model fields
    const updateData = {}
    if (validatedData.name) updateData.name = validatedData.name
    if (validatedData.description !== undefined) updateData.description = validatedData.description
    if (validatedData.pattern) updateData.patternJson = JSON.stringify(validatedData.pattern)
    
    const shiftPattern = await prisma.shiftPattern.update({
      where: { id: id },
      data: updateData
    });

    res.json({
      success: true,
      data: shiftPattern
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
        error: 'Shift pattern not found'
      });
    }

    console.error('Error updating shift pattern:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to update shift pattern'
    });
  }
});

// DELETE /api/shift-patterns/:id - Delete a shift pattern
router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    await prisma.shiftPattern.delete({
      where: { id: id }
    });

    res.json({
      success: true,
      message: 'Shift pattern deleted successfully'
    });
  } catch (error) {
    if (error.code === 'P2025') {
      return res.status(404).json({
        success: false,
        error: 'Shift pattern not found'
      });
    }

    if (error.code === 'P2003') {
      return res.status(400).json({
        success: false,
        error: 'Cannot delete shift pattern: it is referenced by other records'
      });
    }

    console.error('Error deleting shift pattern:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to delete shift pattern'
    });
  }
});

module.exports = router;
