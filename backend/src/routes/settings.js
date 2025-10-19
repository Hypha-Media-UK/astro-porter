const express = require('express');
const { PrismaClient } = require('@prisma/client');
const { z } = require('zod');

const router = express.Router();
const prisma = new PrismaClient();

// Validation schemas
const updateSettingSchema = z.object({
  setting_value: z.string()
});

// Get all settings
router.get('/', async (req, res) => {
  try {
    const settings = await prisma.systemSetting.findMany({
      orderBy: {
        settingKey: 'asc'
      }
    });

    // Convert to key-value object for easier frontend consumption
    const settingsObject = {};
    settings.forEach(setting => {
      settingsObject[setting.settingKey] = setting.settingValue;
    });

    res.json({ success: true, data: settingsObject });
  } catch (error) {
    console.error('Error fetching settings:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch settings' });
  }
});

// Get specific setting
router.get('/:key', async (req, res) => {
  try {
    const settingKey = req.params.key;
    
    const setting = await prisma.systemSetting.findUnique({
      where: { settingKey }
    });

    if (!setting) {
      return res.status(404).json({ success: false, error: 'Setting not found' });
    }

    res.json({ success: true, data: setting });
  } catch (error) {
    console.error('Error fetching setting:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch setting' });
  }
});

// Update setting
router.put('/:key', async (req, res) => {
  try {
    const settingKey = req.params.key;
    const validatedData = updateSettingSchema.parse(req.body);

    const setting = await prisma.systemSetting.upsert({
      where: { settingKey },
      update: {
        settingValue: validatedData.setting_value,
        updatedAt: new Date()
      },
      create: {
        settingKey,
        settingValue: validatedData.setting_value,
        description: `Setting for ${settingKey}`
      }
    });

    res.json({ success: true, data: setting });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ success: false, error: 'Invalid input', details: error.errors });
    }
    console.error('Error updating setting:', error);
    res.status(500).json({ success: false, error: 'Failed to update setting' });
  }
});

// Initialize default settings
router.post('/initialize', async (req, res) => {
  try {
    const defaultSettings = [
      { key: 'day_shift_start', value: '08:00', description: 'Day shift start time' },
      { key: 'day_shift_end', value: '20:00', description: 'Day shift end time' },
      { key: 'night_shift_start', value: '20:00', description: 'Night shift start time' },
      { key: 'night_shift_end', value: '08:00', description: 'Night shift end time' },
      { key: 'minimum_coverage_percentage', value: '75', description: 'Minimum acceptable coverage percentage' },
      { key: 'auto_refresh_interval', value: '300', description: 'Dashboard auto-refresh interval in seconds' },
      { key: 'enable_capability_enforcement', value: 'true', description: 'Enforce capability requirements for assignments' },
      { key: 'default_shift_duration', value: '12', description: 'Default shift duration in hours' }
    ];

    const results = [];
    for (const setting of defaultSettings) {
      const result = await prisma.systemSetting.upsert({
        where: { settingKey: setting.key },
        update: {}, // Don't update if exists
        create: {
          settingKey: setting.key,
          settingValue: setting.value,
          description: setting.description
        }
      });
      results.push(result);
    }

    res.json({ success: true, data: results, message: 'Default settings initialized' });
  } catch (error) {
    console.error('Error initializing settings:', error);
    res.status(500).json({ success: false, error: 'Failed to initialize settings' });
  }
});

// Bulk update settings
router.put('/', async (req, res) => {
  try {
    const settings = req.body;
    
    if (!settings || typeof settings !== 'object') {
      return res.status(400).json({ success: false, error: 'Invalid settings object' });
    }

    const results = [];
    for (const [key, value] of Object.entries(settings)) {
      const setting = await prisma.systemSetting.upsert({
        where: { settingKey: key },
        update: {
          settingValue: String(value),
          updatedAt: new Date()
        },
        create: {
          settingKey: key,
          settingValue: String(value),
          description: `Setting for ${key}`
        }
      });
      results.push(setting);
    }

    res.json({ success: true, data: results, message: 'Settings updated successfully' });
  } catch (error) {
    console.error('Error bulk updating settings:', error);
    res.status(500).json({ success: false, error: 'Failed to update settings' });
  }
});

module.exports = router;
