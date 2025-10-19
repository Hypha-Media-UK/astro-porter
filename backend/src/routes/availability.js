const express = require('express');
const { PrismaClient } = require('@prisma/client');
const { z } = require('zod');

const router = express.Router();
const prisma = new PrismaClient();

// Validation schemas
const createAvailabilitySchema = z.object({
  porter_id: z.string(),
  start_datetime: z.string(),
  end_datetime: z.string(),
  status: z.enum(['AVAILABLE', 'UNAVAILABLE', 'OVERTIME']),
  reason: z.string().optional()
});

const updateAvailabilitySchema = z.object({
  porter_id: z.string().optional(),
  start_datetime: z.string().optional(),
  end_datetime: z.string().optional(),
  status: z.enum(['AVAILABLE', 'UNAVAILABLE', 'OVERTIME']).optional(),
  reason: z.string().optional()
});

// Get all availability records
router.get('/', async (req, res) => {
  try {
    const { porter_id, status, date_from, date_to, active_only } = req.query;
    
    const where = {};
    if (porter_id) where.porterId = porter_id;
    if (status) where.status = status;
    
    // Date range filtering
    if (date_from || date_to) {
      where.AND = [];
      if (date_from) {
        where.AND.push({
          endDatetime: { gte: new Date(date_from) }
        });
      }
      if (date_to) {
        where.AND.push({
          startDatetime: { lte: new Date(date_to) }
        });
      }
    }
    
    // Filter for currently active availability records
    if (active_only === 'true') {
      const now = new Date();
      where.startDatetime = { lte: now };
      where.endDatetime = { gte: now };
    }

    const availability = await prisma.availability.findMany({
      where,
      include: {
        porter: {
          select: { id: true, name: true, contractType: true, porterType: true }
        }
      },
      orderBy: { startDatetime: 'desc' }
    });

    res.json({ success: true, data: availability });
  } catch (error) {
    console.error('Error fetching availability:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch availability' });
  }
});

// Get specific availability record
router.get('/:id', async (req, res) => {
  try {
    const availability = await prisma.availability.findUnique({
      where: { id: req.params.id },
      include: {
        porter: {
          select: { id: true, name: true, contractType: true, porterType: true }
        }
      }
    });

    if (!availability) {
      return res.status(404).json({ success: false, error: 'Availability record not found' });
    }

    res.json({ success: true, data: availability });
  } catch (error) {
    console.error('Error fetching availability:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch availability' });
  }
});

// Create availability record
router.post('/', async (req, res) => {
  try {
    const validatedData = createAvailabilitySchema.parse(req.body);

    // Check for overlapping availability records
    const overlappingRecord = await prisma.availability.findFirst({
      where: {
        porterId: validatedData.porter_id,
        AND: [
          { startDatetime: { lt: new Date(validatedData.end_datetime) } },
          { endDatetime: { gt: new Date(validatedData.start_datetime) } }
        ]
      }
    });

    if (overlappingRecord) {
      return res.status(400).json({ 
        success: false, 
        error: 'Porter already has an availability record during this period' 
      });
    }

    const availability = await prisma.availability.create({
      data: {
        porterId: validatedData.porter_id,
        startDatetime: new Date(validatedData.start_datetime),
        endDatetime: new Date(validatedData.end_datetime),
        status: validatedData.status,
        reason: validatedData.reason
      },
      include: {
        porter: {
          select: { id: true, name: true, contractType: true, porterType: true }
        }
      }
    });

    res.status(201).json({ success: true, data: availability });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ success: false, error: 'Invalid input', details: error.errors });
    }
    console.error('Error creating availability:', error);
    res.status(500).json({ success: false, error: 'Failed to create availability' });
  }
});

// Update availability record
router.put('/:id', async (req, res) => {
  try {
    const validatedData = updateAvailabilitySchema.parse(req.body);

    const updateData = {};
    if (validatedData.porter_id) updateData.porterId = validatedData.porter_id;
    if (validatedData.start_datetime) updateData.startDatetime = new Date(validatedData.start_datetime);
    if (validatedData.end_datetime) updateData.endDatetime = new Date(validatedData.end_datetime);
    if (validatedData.status) updateData.status = validatedData.status;
    if (validatedData.reason !== undefined) updateData.reason = validatedData.reason;

    const availability = await prisma.availability.update({
      where: { id: req.params.id },
      data: updateData,
      include: {
        porter: {
          select: { id: true, name: true, contractType: true, porterType: true }
        }
      }
    });

    res.json({ success: true, data: availability });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ success: false, error: 'Invalid input', details: error.errors });
    }
    console.error('Error updating availability:', error);
    res.status(500).json({ success: false, error: 'Failed to update availability' });
  }
});

// Delete availability record
router.delete('/:id', async (req, res) => {
  try {
    await prisma.availability.delete({
      where: { id: req.params.id }
    });

    res.json({ success: true, message: 'Availability record deleted successfully' });
  } catch (error) {
    console.error('Error deleting availability:', error);
    res.status(500).json({ success: false, error: 'Failed to delete availability' });
  }
});

// Get porter's current availability status
router.get('/porter/:porterId/current', async (req, res) => {
  try {
    const now = new Date();
    
    const availability = await prisma.availability.findFirst({
      where: {
        porterId: req.params.porterId,
        startDatetime: { lte: now },
        endDatetime: { gte: now }
      },
      orderBy: { startDatetime: 'desc' }
    });

    res.json({ success: true, data: availability });
  } catch (error) {
    console.error('Error fetching current availability:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch current availability' });
  }
});

// Get availability summary for a date range
router.get('/summary', async (req, res) => {
  try {
    const { date_from, date_to } = req.query;
    
    if (!date_from || !date_to) {
      return res.status(400).json({ 
        success: false, 
        error: 'date_from and date_to parameters are required' 
      });
    }

    const availability = await prisma.availability.findMany({
      where: {
        AND: [
          { startDatetime: { lte: new Date(date_to) } },
          { endDatetime: { gte: new Date(date_from) } }
        ]
      },
      include: {
        porter: {
          select: { id: true, name: true, contractType: true, porterType: true }
        }
      }
    });

    // Group by status
    const summary = {
      total_records: availability.length,
      by_status: {
        AVAILABLE: availability.filter(a => a.status === 'AVAILABLE').length,
        UNAVAILABLE: availability.filter(a => a.status === 'UNAVAILABLE').length,
        OVERTIME: availability.filter(a => a.status === 'OVERTIME').length
      },
      by_reason: {}
    };

    // Count by reason
    availability.forEach(record => {
      if (record.reason) {
        summary.by_reason[record.reason] = (summary.by_reason[record.reason] || 0) + 1;
      }
    });

    res.json({ success: true, data: summary });
  } catch (error) {
    console.error('Error fetching availability summary:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch availability summary' });
  }
});

// Get unavailable porters for a specific datetime
router.get('/unavailable', async (req, res) => {
  try {
    const { datetime } = req.query;
    
    if (!datetime) {
      return res.status(400).json({ 
        success: false, 
        error: 'datetime parameter is required' 
      });
    }

    const targetDate = new Date(datetime);
    
    const unavailablePorters = await prisma.availability.findMany({
      where: {
        status: 'UNAVAILABLE',
        startDatetime: { lte: targetDate },
        endDatetime: { gte: targetDate }
      },
      include: {
        porter: {
          select: { id: true, name: true, contractType: true, porterType: true }
        }
      }
    });

    res.json({ success: true, data: unavailablePorters });
  } catch (error) {
    console.error('Error fetching unavailable porters:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch unavailable porters' });
  }
});

module.exports = router;
