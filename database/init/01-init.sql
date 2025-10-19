-- Initialize Porter Management Database
-- This script runs automatically when the database container starts

-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS porter_management;

-- Grant privileges to the porter_user
GRANT ALL PRIVILEGES ON porter_management.* TO 'porter_user'@'%';
FLUSH PRIVILEGES;

-- Use the database
USE porter_management;

-- Log initialization
SELECT 'Porter Management Database initialized successfully' as message;
