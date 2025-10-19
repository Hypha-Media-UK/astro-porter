import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting database seed...');

  // Create system settings
  console.log('📝 Creating system settings...');
  await prisma.systemSetting.createMany({
    data: [
      {
        settingKey: 'day_shift_start',
        settingValue: '08:00',
        description: 'Default day shift start time'
      },
      {
        settingKey: 'day_shift_end',
        settingValue: '20:00',
        description: 'Default day shift end time'
      },
      {
        settingKey: 'night_shift_start',
        settingValue: '20:00',
        description: 'Default night shift start time'
      },
      {
        settingKey: 'night_shift_end',
        settingValue: '08:00',
        description: 'Default night shift end time'
      },
      {
        settingKey: 'enforce_capability_expiry',
        settingValue: 'false',
        description: 'Whether to strictly enforce capability expiry dates'
      }
    ],
    skipDuplicates: true
  });

  // Create sample building
  console.log('🏢 Creating sample building...');
  const building = await prisma.building.create({
    data: {
      name: 'Main Hospital',
      location: 'City Centre',
      description: 'Primary hospital facility'
    }
  });

  // Create sample capabilities
  console.log('🎯 Creating sample capabilities...');
  const capabilities = await prisma.capability.createMany({
    data: [
      { name: 'Theatre Access', description: 'Access to operating theatres' },
      { name: 'MRI Clearance', description: 'Cleared for MRI environment' },
      { name: 'Radiation Safety', description: 'Radiation safety training' },
      { name: 'Forklift Licence', description: 'Licensed to operate forklift' },
      { name: 'Patient Transport', description: 'Qualified for patient transport' }
    ],
    skipDuplicates: true
  });

  // Create sample shift pattern
  console.log('🔄 Creating sample shift pattern...');
  const shiftPattern = await prisma.shiftPattern.create({
    data: {
      name: '4 on 4 off Pattern',
      description: '4 days on, 4 days off rotation',
      patternJson: JSON.stringify([
        { type: 'day', label: 'Day Shift', duration_days: 4 },
        { type: 'off', label: 'Rest', duration_days: 4 }
      ])
    }
  });

  // Create sample shift
  console.log('⏰ Creating sample shift...');
  const shift = await prisma.shift.create({
    data: {
      name: 'Day Shift A',
      patternId: shiftPattern.id,
      shiftMode: 'DAY',
      ident: 'A',
      daysOn: 4,
      daysOff: 4,
      offsetDays: 0,
      groundZero: new Date('2024-01-01')
    }
  });

  // Create sample department schedule
  console.log('📅 Creating sample department schedule...');
  const schedule = await prisma.departmentSchedule.create({
    data: {
      name: 'Standard Weekday Schedule',
      description: 'Monday to Friday operational hours',
      periods: {
        create: [
          {
            dayOfWeek: 'MONDAY',
            openTime: '08:00',
            closeTime: '18:00',
            requiredPorters: 3
          },
          {
            dayOfWeek: 'TUESDAY',
            openTime: '08:00',
            closeTime: '18:00',
            requiredPorters: 3
          },
          {
            dayOfWeek: 'WEDNESDAY',
            openTime: '08:00',
            closeTime: '18:00',
            requiredPorters: 3
          },
          {
            dayOfWeek: 'THURSDAY',
            openTime: '08:00',
            closeTime: '18:00',
            requiredPorters: 3
          },
          {
            dayOfWeek: 'FRIDAY',
            openTime: '08:00',
            closeTime: '18:00',
            requiredPorters: 3
          }
        ]
      }
    }
  });

  // Create sample department
  console.log('🏥 Creating sample department...');
  const department = await prisma.department.create({
    data: {
      name: 'Radiology',
      buildingId: building.id,
      scheduleId: schedule.id,
      description: 'Medical imaging department',
      is247: false
    }
  });

  // Create sample service
  console.log('🔧 Creating sample service...');
  const service = await prisma.service.create({
    data: {
      name: 'Patient Transport',
      departmentId: department.id,
      description: 'Transport patients to and from radiology',
      isActive: true,
      inheritsSchedule: true
    }
  });

  // Create sample porter
  console.log('👤 Creating sample porter...');
  const porter = await prisma.porter.create({
    data: {
      name: 'John Smith',
      contractType: 'SHIFT',
      shiftId: shift.id,
      regularDepartmentId: department.id,
      porterType: 'PORTER',
      countsTowardsStaffing: true
    }
  });

  console.log('✅ Database seed completed successfully!');
  console.log(`📊 Created:
  - 1 Building: ${building.name}
  - 1 Department: ${department.name}
  - 1 Service: ${service.name}
  - 1 Porter: ${porter.name}
  - 1 Shift Pattern: ${shiftPattern.name}
  - 5 Capabilities
  - 5 System Settings`);
}

main()
  .catch((e) => {
    console.error('❌ Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
