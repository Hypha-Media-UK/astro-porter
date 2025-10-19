const express = require('express');
const { PrismaClient } = require('@prisma/client');
const { z } = require('zod');

const router = express.Router();
const prisma = new PrismaClient();

// Validation schemas
const createDepartmentSchema = z.object({
  name: z.string().min(1).max(255),
  building_id: z.string().min(1),
  description: z.string().optional(),
  is_24_7: z.boolean().default(false)
});

const updateDepartmentSchema = z.object({
  name: z.string().min(1).max(255).optional(),
  building_id: z.string().min(1).optional(),
  description: z.string().optional(),
  is_24_7: z.boolean().optional()
});

// GET /api/departments - List all departments
router.get('/', async (req, res) => {
  try {
    const departments = await prisma.department.findMany({
      include: {
        building: true,
        services: true
      },
      orderBy: {
        name: 'asc'
      }
    });

    res.json({
      success: true,
      data: departments
    });
  } catch (error) {
    console.error('Error fetching departments:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch departments'
    });
  }
});

// GET /api/departments/:id - Get a specific department
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    const department = await prisma.department.findUnique({
      where: { id: id },
      include: {
        building: true,
        services: true
      }
    });

    if (!department) {
      return res.status(404).json({
        success: false,
        error: 'Department not found'
      });
    }

    res.json({
      success: true,
      data: department
    });
  } catch (error) {
    console.error('Error fetching department:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch department'
    });
  }
});

// POST /api/departments - Create a new department
router.post('/', async (req, res) => {
  try {
    const validatedData = createDepartmentSchema.parse(req.body);
    
    // Check if building exists
    const building = await prisma.building.findUnique({
      where: { id: validatedData.building_id }
    });

    if (!building) {
      return res.status(400).json({
        success: false,
        error: 'Building not found'
      });
    }
    
    const department = await prisma.department.create({
      data: {
        name: validatedData.name,
        buildingId: validatedData.building_id,
        description: validatedData.description,
        is247: validatedData.is_24_7
      },
      include: {
        building: true,
        services: true
      }
    });

    res.status(201).json({
      success: true,
      data: department
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({
        success: false,
        error: 'Validation error',
        details: error.errors
      });
    }

    console.error('Error creating department:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to create department'
    });
  }
});

// PUT /api/departments/:id - Update a department
router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const validatedData = updateDepartmentSchema.parse(req.body);
    
    // Check if building exists (if building_id is being updated)
    if (validatedData.building_id) {
      const building = await prisma.building.findUnique({
        where: { id: validatedData.building_id }
      });

      if (!building) {
        return res.status(400).json({
          success: false,
          error: 'Building not found'
        });
      }
    }
    
    // Map API fields to Prisma model fields
    const updateData = {}
    if (validatedData.name) updateData.name = validatedData.name
    if (validatedData.building_id) updateData.buildingId = validatedData.building_id
    if (validatedData.description !== undefined) updateData.description = validatedData.description
    if (validatedData.is_24_7 !== undefined) updateData.is247 = validatedData.is_24_7

    const department = await prisma.department.update({
      where: { id: id },
      data: updateData,
      include: {
        building: true,
        services: true
      }
    });

    res.json({
      success: true,
      data: department
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
        error: 'Department not found'
      });
    }

    console.error('Error updating department:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to update department'
    });
  }
});

// DELETE /api/departments/:id - Delete a department
router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    await prisma.department.delete({
      where: { id: id }
    });

    res.json({
      success: true,
      message: 'Department deleted successfully'
    });
  } catch (error) {
    if (error.code === 'P2025') {
      return res.status(404).json({
        success: false,
        error: 'Department not found'
      });
    }

    if (error.code === 'P2003') {
      return res.status(400).json({
        success: false,
        error: 'Cannot delete department with existing services or allocations'
      });
    }

    console.error('Error deleting department:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to delete department'
    });
  }
});

module.exports = router;
