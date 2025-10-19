const express = require('express');
const { PrismaClient } = require('@prisma/client');
const { z } = require('zod');

const router = express.Router();
const prisma = new PrismaClient();

// Validation schemas
const createBuildingSchema = z.object({
  name: z.string().min(1).max(255),
  location: z.string().optional(),
  description: z.string().optional()
});

const updateBuildingSchema = z.object({
  name: z.string().min(1).max(255).optional(),
  location: z.string().optional(),
  description: z.string().optional()
});

// GET /api/buildings - List all buildings
router.get('/', async (req, res) => {
  try {
    const buildings = await prisma.building.findMany({
      include: {
        departments: {
          include: {
            services: true
          }
        }
      },
      orderBy: {
        name: 'asc'
      }
    });

    res.json({
      success: true,
      data: buildings
    });
  } catch (error) {
    console.error('Error fetching buildings:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch buildings'
    });
  }
});

// GET /api/buildings/:id - Get a specific building
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    const building = await prisma.building.findUnique({
      where: { id: parseInt(id) },
      include: {
        departments: {
          include: {
            services: true
          }
        }
      }
    });

    if (!building) {
      return res.status(404).json({
        success: false,
        error: 'Building not found'
      });
    }

    res.json({
      success: true,
      data: building
    });
  } catch (error) {
    console.error('Error fetching building:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch building'
    });
  }
});

// POST /api/buildings - Create a new building
router.post('/', async (req, res) => {
  try {
    const validatedData = createBuildingSchema.parse(req.body);
    
    const building = await prisma.building.create({
      data: validatedData,
      include: {
        departments: {
          include: {
            services: true
          }
        }
      }
    });

    res.status(201).json({
      success: true,
      data: building
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({
        success: false,
        error: 'Validation error',
        details: error.errors
      });
    }

    console.error('Error creating building:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to create building'
    });
  }
});

// PUT /api/buildings/:id - Update a building
router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const validatedData = updateBuildingSchema.parse(req.body);
    
    const building = await prisma.building.update({
      where: { id: parseInt(id) },
      data: validatedData,
      include: {
        departments: {
          include: {
            services: true
          }
        }
      }
    });

    res.json({
      success: true,
      data: building
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
        error: 'Building not found'
      });
    }

    console.error('Error updating building:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to update building'
    });
  }
});

// DELETE /api/buildings/:id - Delete a building
router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    await prisma.building.delete({
      where: { id: parseInt(id) }
    });

    res.json({
      success: true,
      message: 'Building deleted successfully'
    });
  } catch (error) {
    if (error.code === 'P2025') {
      return res.status(404).json({
        success: false,
        error: 'Building not found'
      });
    }

    if (error.code === 'P2003') {
      return res.status(400).json({
        success: false,
        error: 'Cannot delete building with existing departments'
      });
    }

    console.error('Error deleting building:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to delete building'
    });
  }
});

module.exports = router;
