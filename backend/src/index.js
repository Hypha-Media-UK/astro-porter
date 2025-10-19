const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const dotenv = require('dotenv');

// Load environment variables
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(helmet());
app.use(cors({
  origin: process.env.CORS_ORIGIN || 'http://localhost:4321',
  credentials: true
}));
app.use(morgan('combined'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    timestamp: new Date().toISOString(),
    service: 'porter-management-backend'
  });
});

// Import API routes
const buildingsRouter = require('./routes/buildings');
const departmentsRouter = require('./routes/departments');
const servicesRouter = require('./routes/services');
const portersRouter = require('./routes/porters');
const shiftsRouter = require('./routes/shifts');
const shiftPatternsRouter = require('./routes/shift-patterns');
const coverageRouter = require('./routes/coverage');
const settingsRouter = require('./routes/settings');
const capabilitiesRouter = require('./routes/capabilities');
const allocationsRouter = require('./routes/allocations');
const availabilityRouter = require('./routes/availability');

// API routes
app.use('/api/buildings', buildingsRouter);
app.use('/api/departments', departmentsRouter);
app.use('/api/services', servicesRouter);
app.use('/api/porters', portersRouter);
app.use('/api/shifts', shiftsRouter);
app.use('/api/shift-patterns', shiftPatternsRouter);
app.use('/api/coverage', coverageRouter);
app.use('/api/settings', settingsRouter);
app.use('/api/capabilities', capabilitiesRouter);
app.use('/api/allocations', allocationsRouter);
app.use('/api/availability', availabilityRouter);

// API base route
app.get('/api', (req, res) => {
  res.json({
    message: 'Porter Management API',
    version: '1.0.0',
    endpoints: {
      health: '/health',
      buildings: '/api/buildings',
      departments: '/api/departments',
      services: '/api/services',
      porters: '/api/porters'
    }
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ 
    error: 'Something went wrong!',
    message: process.env.NODE_ENV === 'development' ? err.message : 'Internal server error'
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({ 
    error: 'Not found',
    path: req.originalUrl 
  });
});

// Start server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Porter Management Backend running on port ${PORT}`);
  console.log(`📊 Health check: http://localhost:${PORT}/health`);
  console.log(`🔗 API base: http://localhost:${PORT}/api`);
});
