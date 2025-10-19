const express = require('express');
const { PrismaClient } = require('@prisma/client');
const { z } = require('zod');

const router = express.Router();
const prisma = new PrismaClient();

// Validation schemas
const createCapabilitySchema = z.object({
  name: z.string().min(1),
  description: z.string().optional()
});

const updateCapabilitySchema = z.object({
  name: z.string().min(1).optional(),
  description: z.string().optional()
});

const assignPorterCapabilitySchema = z.object({
  porter_id: z.string(),
  capability_id: z.string(),
  expiry_date: z.string().optional()
});

const assignDepartmentCapabilitySchema = z.object({
  department_id: z.string(),
  capability_id: z.string(),
  required_level: z.enum(['REQUIRED', 'PREFERRED'])
});

const assignServiceCapabilitySchema = z.object({
  service_id: z.string(),
  capability_id: z.string(),
  required_level: z.enum(['REQUIRED', 'PREFERRED'])
});

// Get all capabilities
router.get('/', async (req, res) => {
  try {
    const capabilities = await prisma.capability.findMany({
      include: {
        porterCapabilities: {
          include: {
            porter: {
              select: { id: true, name: true }
            }
          }
        },
        departmentCapabilities: {
          include: {
            department: {
              select: { id: true, name: true }
            }
          }
        },
        serviceCapabilities: {
          include: {
            service: {
              select: { id: true, name: true }
            }
          }
        }
      },
      orderBy: { name: 'asc' }
    });

    res.json({ success: true, data: capabilities });
  } catch (error) {
    console.error('Error fetching capabilities:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch capabilities' });
  }
});

// Get specific capability
router.get('/:id', async (req, res) => {
  try {
    const capability = await prisma.capability.findUnique({
      where: { id: req.params.id },
      include: {
        porterCapabilities: {
          include: {
            porter: {
              select: { id: true, name: true }
            }
          }
        },
        departmentCapabilities: {
          include: {
            department: {
              select: { id: true, name: true }
            }
          }
        },
        serviceCapabilities: {
          include: {
            service: {
              select: { id: true, name: true }
            }
          }
        }
      }
    });

    if (!capability) {
      return res.status(404).json({ success: false, error: 'Capability not found' });
    }

    res.json({ success: true, data: capability });
  } catch (error) {
    console.error('Error fetching capability:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch capability' });
  }
});

// Create capability
router.post('/', async (req, res) => {
  try {
    const validatedData = createCapabilitySchema.parse(req.body);

    const capability = await prisma.capability.create({
      data: {
        name: validatedData.name,
        description: validatedData.description
      }
    });

    res.status(201).json({ success: true, data: capability });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ success: false, error: 'Invalid input', details: error.errors });
    }
    console.error('Error creating capability:', error);
    res.status(500).json({ success: false, error: 'Failed to create capability' });
  }
});

// Update capability
router.put('/:id', async (req, res) => {
  try {
    const validatedData = updateCapabilitySchema.parse(req.body);

    const capability = await prisma.capability.update({
      where: { id: req.params.id },
      data: validatedData
    });

    res.json({ success: true, data: capability });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ success: false, error: 'Invalid input', details: error.errors });
    }
    console.error('Error updating capability:', error);
    res.status(500).json({ success: false, error: 'Failed to update capability' });
  }
});

// Delete capability
router.delete('/:id', async (req, res) => {
  try {
    await prisma.capability.delete({
      where: { id: req.params.id }
    });

    res.json({ success: true, message: 'Capability deleted successfully' });
  } catch (error) {
    console.error('Error deleting capability:', error);
    res.status(500).json({ success: false, error: 'Failed to delete capability' });
  }
});

// Assign capability to porter
router.post('/porter', async (req, res) => {
  try {
    const validatedData = assignPorterCapabilitySchema.parse(req.body);

    const porterCapability = await prisma.porterCapability.create({
      data: {
        porterId: validatedData.porter_id,
        capabilityId: validatedData.capability_id,
        expiryDate: validatedData.expiry_date ? new Date(validatedData.expiry_date) : null
      },
      include: {
        porter: { select: { id: true, name: true } },
        capability: { select: { id: true, name: true } }
      }
    });

    res.status(201).json({ success: true, data: porterCapability });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ success: false, error: 'Invalid input', details: error.errors });
    }
    console.error('Error assigning porter capability:', error);
    res.status(500).json({ success: false, error: 'Failed to assign porter capability' });
  }
});

// Assign capability to department
router.post('/department', async (req, res) => {
  try {
    const validatedData = assignDepartmentCapabilitySchema.parse(req.body);

    const departmentCapability = await prisma.departmentCapability.create({
      data: {
        departmentId: validatedData.department_id,
        capabilityId: validatedData.capability_id,
        requiredLevel: validatedData.required_level
      },
      include: {
        department: { select: { id: true, name: true } },
        capability: { select: { id: true, name: true } }
      }
    });

    res.status(201).json({ success: true, data: departmentCapability });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ success: false, error: 'Invalid input', details: error.errors });
    }
    console.error('Error assigning department capability:', error);
    res.status(500).json({ success: false, error: 'Failed to assign department capability' });
  }
});

// Assign capability to service
router.post('/service', async (req, res) => {
  try {
    const validatedData = assignServiceCapabilitySchema.parse(req.body);

    const serviceCapability = await prisma.serviceCapability.create({
      data: {
        serviceId: validatedData.service_id,
        capabilityId: validatedData.capability_id,
        requiredLevel: validatedData.required_level
      },
      include: {
        service: { select: { id: true, name: true } },
        capability: { select: { id: true, name: true } }
      }
    });

    res.status(201).json({ success: true, data: serviceCapability });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ success: false, error: 'Invalid input', details: error.errors });
    }
    console.error('Error assigning service capability:', error);
    res.status(500).json({ success: false, error: 'Failed to assign service capability' });
  }
});

module.exports = router;
