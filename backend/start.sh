#!/bin/bash

echo "🚀 Starting Porter Management Backend..."

# Wait for database to be ready
echo "⏳ Waiting for database connection..."
npx wait-on tcp:database:3306 --timeout 60000

# Generate Prisma client
echo "🔧 Generating Prisma client..."
npx prisma generate

# Run database migrations
echo "📊 Running database migrations..."
npx prisma migrate deploy

# Check if we need to seed the database
echo "🌱 Checking if database needs seeding..."
if npx prisma db seed --preview-feature 2>/dev/null; then
  echo "✅ Database seeded successfully"
else
  echo "ℹ️  Database already seeded or seed failed"
fi

# Start the application
echo "🎯 Starting Express server..."
npm run dev
