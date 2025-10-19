const express = require('express');
const { PrismaClient } = require('@prisma/client');
const { z } = require('zod');

const router = express.Router();
const prisma = new PrismaClient();

// Validation schemas
const createServiceSchema = z.object({
  name: z.string().min(1).max(255),
  department_id: z.string().min(1),
  description: z.string().optional(),
  uses_custom_schedule: z.boolean().default(false)
});

const updateServiceSchema = z.object({
  name: z.string().min(1).max(255).optional(),
  department_id: z.string().min(1).optional(),
  description: z.string().optional(),
  uses_custom_schedule: z.boolean().optional()
});

// GET /api/services - List all services
router.get('/', async (req, res) => {
  try {
    const services = await prisma.service.findMany({
      include: {
        department: {
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
      data: services
    });
  } catch (error) {
    console.error('Error fetching services:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch services'
    });
  }
});

// GET /api/services/:id - Get a specific service
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    const service = await prisma.service.findUnique({
      where: { id: id },
      include: {
        department: {
          include: {
            building: true
          }
        }
      }
    });

    if (!service) {
      return res.status(404).json({
        success: false,
        error: 'Service not found'
      });
    }

    res.json({
      success: true,
      data: service
    });
  } catch (error) {
    console.error('Error fetching service:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch service'
    });
  }
});

// POST /api/services - Create a new service
router.post('/', async (req, res) => {
  try {
    const validatedData = createServiceSchema.parse(req.body);
    
    // Check if department exists
    const department = await prisma.department.findUnique({
      where: { id: validatedData.department_id }
    });

    if (!department) {
      return res.status(400).json({
        success: false,
        error: 'Department not found'
      });
    }
    
    const service = await prisma.service.create({
      data: {
        name: validatedData.name,
        departmentId: validatedData.department_id,
        description: validatedData.description,
        inheritsSchedule: !validatedData.uses_custom_schedule // Inverted logic
      },
      include: {
        department: {
          include: {
            building: true
          }
        }
      }
    });

    res.status(201).json({
      success: true,
      data: service
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({
        success: false,
        error: 'Validation error',
        details: error.errors
      });
    }

    console.error('Error creating service:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to create service'
    });
  }
});

// PUT /api/services/:id - Update a service
router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const validatedData = updateServiceSchema.parse(req.body);
    
    // Check if department exists (if department_id is being updated)
    if (validatedData.department_id) {
      const department = await prisma.department.findUnique({
        where: { id: validatedData.department_id }
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
    if (validatedData.department_id) updateData.departmentId = validatedData.department_id
    if (validatedData.description !== undefined) updateData.description = validatedData.description
    if (validatedData.uses_custom_schedule !== undefined) updateData.inheritsSchedule = !validatedData.uses_custom_schedule

    const service = await prisma.service.update({
      where: { id: id },
      data: updateData,
      include: {
        department: {
          include: {
            building: true
          }
        }
      }
    });

    res.json({
      success: true,
      data: service
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
        error: 'Service not found'
      });
    }

    console.error('Error updating service:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to update service'
    });
  }
});

// DELETE /api/services/:id - Delete a service
router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    await prisma.service.delete({
      where: { id: id }
    });

    res.json({
      success: true,
      message: 'Service deleted successfully'
    });
  } catch (error) {
    if (error.code === 'P2025') {
      return res.status(404).json({
        success: false,
        error: 'Service not found'
      });
    }

    if (error.code === 'P2003') {
      return res.status(400).json({
        success: false,
        error: 'Cannot delete service with existing allocations'
      });
    }

    console.error('Error deleting service:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to delete service'
    });
  }
});

module.exports = router;
