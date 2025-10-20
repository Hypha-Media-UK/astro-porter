const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting comprehensive database seeding...');

  // Clear existing data
  console.log('🧹 Clearing existing data...');
  await prisma.shift.deleteMany();
  await prisma.porter.deleteMany();
  await prisma.department.deleteMany();
  await prisma.service.deleteMany();
  await prisma.building.deleteMany();

  console.log('✅ Database cleared');

  // We'll create services after departments since they require departmentId

  // Create buildings
  console.log('🏢 Creating buildings...');
  const buildingNames = [
    'Charlesworth', 'Ladysmith', 'Buckton Building', 'Etherow Building', 
    'New Century House', 'Werneth House', 'Stamford Unit', 'Renal Unit', 
    'Main Stores', 'Silver Springs', 'Springhill', 'Hartshead', 
    'Macmillan Unit', 'Astley House', 'Portland House', 'Mellor House'
  ];

  const buildings = [];
  for (const buildingName of buildingNames) {
    const building = await prisma.building.create({
      data: {
        name: buildingName,
        location: 'Hospital Campus',
        description: `${buildingName} facility`
      }
    });
    buildings.push(building);
  }

  console.log(`✅ Created ${buildings.length} buildings`);

  // Create departments
  console.log('🏥 Creating departments...');
  const departmentData = [
    { building: 'Charlesworth', departments: ['Ward 27', 'Ward 30 (HCU)', 'Ward 31', 'Acorn Birth Center', 'Labour Ward', 'NICU', 'Maternity Triage', 'Women\'s Health', 'Ante-Natal Unit', 'Security'] },
    { building: 'Ladysmith', departments: ['Ward 40', 'Ward 41', 'Ward 42', 'Ward 43', 'Ward 44', 'Ward 45', 'Ward 46', 'Xray 4'] },
    { building: 'Buckton Building', departments: ['Walkerwood Unit'] },
    { building: 'Etherow Building', departments: ['Saxon Ward', 'Summers Ward', 'Hague Ward'] },
    { building: 'New Century House', departments: ['Infection Control', 'Library'] },
    { building: 'Werneth House', departments: ['Lecture Theatre', 'Classrooms'] },
    { building: 'Stamford Unit', departments: ['Stamford Ground', 'Stamford 1st Floor', 'Stamford 2nd Floor'] },
    { building: 'Renal Unit', departments: ['Renal Ward'] },
    { building: 'Main Stores', departments: ['Supplies'] },
    { building: 'Silver Springs', departments: ['Offices'] },
    { building: 'Springhill', departments: ['Offices'] },
    { building: 'Hartshead', departments: ['AMU', 'IAU', 'ACU', 'ITU', 'Theatres North', 'Theatres South', 'DSEU', 'Children\'s O+A', 'Children\'s Unit', 'Children\'s Outpatients', 'Clinics A-F', 'G/F Xray', 'Green Suite', 'Plaster Room', 'Discharge Lounge', 'ISGU', 'ED (A+E)', 'L/G/F Xray', 'L/G/F CT Scan', 'MRI', 'Walk in Center', 'Mattress Store', 'Pharmacy', 'Swan Room', 'Parking Office', 'CRI'] },
    { building: 'Macmillan Unit', departments: ['Macmillan'] },
    { building: 'Astley House', departments: ['Mattress Store'] },
    { building: 'Portland House', departments: ['Laundry'] },
    { building: 'Mellor House', departments: ['Meeting Rooms', 'Porters Lodge', 'I.T.', 'Equipment Repair'] }
  ];

  const departments = [];
  for (const buildingData of departmentData) {
    const building = buildings.find(b => b.name === buildingData.building);
    if (building) {
      for (const deptName of buildingData.departments) {
        const department = await prisma.department.create({
          data: {
            name: deptName,
            buildingId: building.id,
            description: `${deptName} in ${building.name}`,
            is247: ['ED (A+E)', 'ITU', 'AMU', 'IAU', 'ACU'].includes(deptName)
          }
        });
        departments.push(department);
      }
    }
  }

  console.log(`✅ Created ${departments.length} departments`);

  // Create services
  console.log('🔧 Creating services...');
  const serviceNames = [
    'Patient Transport', 'District Drivers', 'Medical Records', 'Post', 'Stores',
    'Blood Drivers', 'Laundry', 'External Waste', 'Ad-Hoc', 'Pharmacy'
  ];

  const services = [];
  for (const serviceName of serviceNames) {
    // Assign services to appropriate departments or use a general department
    let departmentId = departments[0].id; // Default to first department

    // Try to find a more appropriate department
    if (serviceName === 'Patient Transport') {
      const dept = departments.find(d => d.name === 'ED (A+E)' || d.name === 'AMU');
      if (dept) departmentId = dept.id;
    } else if (serviceName === 'Medical Records') {
      const dept = departments.find(d => d.name.includes('Office') || d.name === 'Library');
      if (dept) departmentId = dept.id;
    } else if (serviceName === 'Pharmacy') {
      const dept = departments.find(d => d.name === 'Pharmacy');
      if (dept) departmentId = dept.id;
    } else if (serviceName === 'Laundry') {
      const dept = departments.find(d => d.name === 'Laundry');
      if (dept) departmentId = dept.id;
    } else if (serviceName === 'Stores') {
      const dept = departments.find(d => d.name === 'Supplies' || d.name.includes('Store'));
      if (dept) departmentId = dept.id;
    }

    const service = await prisma.service.create({
      data: {
        name: serviceName,
        departmentId: departmentId,
        description: `${serviceName} service`,
        isActive: true
      }
    });
    services.push(service);
  }

  console.log(`✅ Created ${services.length} services`);

  // Create porters
  console.log('👥 Creating porters...');
  const porterData = [
    { name: 'Martin Smith', type: 'Supervisor', shift: '', department: '', service: '' },
    { name: 'Chris Crombie', type: 'Supervisor', shift: '', department: '', service: '' },
    { name: 'Martin Fearon', type: 'Supervisor', shift: '', department: '', service: '' },
    { name: 'Luke Clements', type: 'Supervisor', shift: '', department: '', service: '' },
    { name: 'Chris Threadgold', type: 'Supervisor', shift: '', department: '', service: '' },
    { name: 'Rob Mcpartland', type: 'General', shift: '4 on 4 off', department: '', service: '' },
    { name: 'John Evans', type: 'General', shift: '4 on 4 off', department: '', service: '' },
    { name: 'Charlotte Rimmer', type: 'General', shift: '4 on 4 off', department: '', service: '' },
    { name: 'Carla Barton', type: 'General', shift: '4 on 4 off', department: '', service: '' },
    { name: 'Andrew Trudgeon', type: 'General', shift: '4 on 4 off', department: '', service: '' },
    { name: 'Stepen Bowater', type: 'General', shift: '4 on 4 off', department: '', service: 'Patient Transport' },
    { name: 'Matthew Bennett', type: 'General', shift: '4 on 4 off', department: '', service: '' },
    { name: 'Stephen Scarsbrook', type: 'General', shift: '4 on 4 off', department: '', service: '' },
    { name: 'Jordon Fish', type: 'General', shift: '4 on 4 off', department: '', service: '' },
    { name: 'Steven Richardson', type: 'General', shift: '4 on 4 off', department: '', service: '' },
    { name: 'Chris Roach', type: 'Relief', shift: '4 on 4 off', department: '', service: '' },
    { name: 'Simon Collins', type: 'Relief', shift: '', department: '', service: '' },
    { name: 'Mark Walton', type: 'General', shift: '', department: '', service: '', hours: '06:00 - 14:00', days: 'Weds-Sun' },
    { name: 'Allen Butler', type: 'General', shift: '', department: '', service: '' },
    { name: 'Steven Richardson', type: 'Relief', shift: '4 on 4 off', department: '', service: '' },
    { name: 'Simon Collins', type: 'General', shift: '', department: '', service: '' },
    { name: 'Darren Flowers', type: 'General', shift: '4 on 4 off (Night)', department: '', service: '', hours: '09:00 - 17:00' },
    { name: 'Brian Cassidy', type: 'General', shift: '4 on 4 off (Night)', department: '', service: '' },
    { name: 'Karen Blackett', type: 'General', shift: '4 on 4 off (Night)', department: '', service: '' },
    { name: 'James Mitchell', type: 'General', shift: '4 on 4 off (Night)', department: '', service: '' },
    { name: 'Alan Kelly', type: 'General', shift: '4 on 4 off (Night)', department: '', service: '' },
    { name: 'Tomas Konkol', type: 'General', shift: '4 on 4 off (Night)', department: '', service: '' },
    { name: 'Kyle Blackshaw', type: 'Relief', shift: '', department: '', service: '' },
    { name: 'David Sykes', type: 'Relief', shift: '4 on 4 off (Night)', department: '', service: '' },
    { name: 'Stuart Ford', type: 'General', shift: '', department: 'ED (A+E)', service: '' },
    { name: 'Lee Stafford', type: 'General', shift: '', department: 'ED (A+E)', service: '' },
    { name: 'Nicola Benger', type: 'General', shift: '', department: 'ED (A+E)', service: '' },
    { name: 'Jeff Robinson', type: 'General', shift: '', department: 'AMU', service: '' },
    { name: 'Dean Pickering', type: 'General', shift: '', department: 'G/F Xray', service: '' },
    { name: 'Colin Bromley', type: 'General', shift: '4 on 4 off', department: '', service: 'Patient Transport' },
    { name: 'Gary Booth', type: 'General', shift: '4 on 4 off', department: '', service: 'Patient Transport' },
    { name: 'Ian Moss', type: 'General', shift: '4 on 4 off', department: '', service: 'Patient Transport' },
    { name: 'Paul Fisher', type: 'General', shift: '4 on 4 off', department: '', service: 'Patient Transport' },
    { name: 'Stephen Kirk', type: 'General', shift: '4 on 4 off (Night)', department: '', service: '' },
    { name: 'Ian Speakes', type: 'General', shift: '', department: '', service: 'District Drivers' },
    { name: 'Stuart Lomas', type: 'General', shift: '', department: 'ED (A+E)', service: '' },
    { name: 'Stephen Cooper', type: 'General', shift: '4 on 4 off', department: '', service: '' },
    { name: 'Darren Milhench', type: 'General', shift: '4 on 4 off', department: '', service: '' },
    { name: 'Darren Mycroft', type: 'General', shift: '4 on 4 off', department: '', service: '' },
    { name: 'Kevin Gaskell', type: 'Relief', shift: '', department: '', service: '', hours: '14:00 - 22:00', days: 'Mon-Fri' },
    { name: 'Merv Permalloo', type: 'General', shift: '4 on 4 off', department: '', service: '' },
    { name: 'Regan Stringer', type: 'General', shift: '4 on 4 off', department: '', service: '' },
    { name: 'Matthew Cope', type: 'General', shift: '4 on 4 off', department: '', service: '' },
    { name: 'AJ', type: 'General', shift: '4 on 4 off', department: '', service: '' },
    { name: 'Michael Shaw', type: 'General', shift: '4 on 4 off', department: '', service: '' },
    { name: 'James Bennett', type: 'General', shift: '', department: '', service: '', hours: '06:00 - 14:00', days: 'Mon-Weds' },
    { name: 'Martin Hobson', type: 'General', shift: '4 on 4 off (Night)', department: '', service: '' },
    { name: 'Martin Kenyon', type: 'General', shift: '4 on 4 off (Night)', department: '', service: '' },
    { name: 'Scott Cartledge', type: 'General', shift: '4 on 4 off (Night)', department: '', service: '' },
    { name: 'Tony Batters', type: 'General', shift: '4 on 4 off (Night)', department: '', service: '' },
    { name: 'Lewis Yearsley', type: 'General', shift: '4 on 4 off (Night)', department: '', service: '' },
    { name: 'Mark Lloyd', type: 'General', shift: '', department: 'G/F Xray', service: '' },
    { name: 'Stephen Burke', type: 'General', shift: '', department: 'G/F Xray', service: '' },
    { name: 'Julie Greenough', type: 'General', shift: '', department: 'L/G/F CT Scan', service: '' },
    { name: 'Edward Collier', type: 'General', shift: '', department: 'L/G/F CT Scan', service: '' },
    { name: 'Phil Hollinshead', type: 'General', shift: '', department: 'L/G/F Xray', service: '' },
    { name: 'Kevin Tomlinson', type: 'General', shift: '', department: '', service: '', hours: '12:00 - 20:00', days: 'Mon-Fri' },
    { name: 'Soloman Offei', type: 'General', shift: '', department: '', service: '' },
    { name: 'Colin Bromley', type: 'Relief', shift: '', department: '', service: '' },
    { name: 'Lynne Warner', type: 'General', shift: '', department: '', service: 'Patient Transport', hours: '12:00 - 20:00', days: 'Mon-Fri' },
    { name: 'Roy Harris', type: 'General', shift: '', department: '', service: 'Patient Transport', hours: '12:00 - 20:00', days: 'Mon-Fri' },
    { name: 'Kyle Sanderson', type: 'General', shift: '', department: '', service: 'Medical Records', days: 'Mon-Fri' },
    { name: 'Peter Moss', type: 'General', shift: '', department: '', service: 'Medical Records', days: 'Mon-Fri' },
    { name: 'Chris Wardle', type: 'General', shift: '', department: '', service: 'Medical Records', days: 'Mon-Fri' },
    { name: 'Eloisa Andrew', type: 'General', shift: '', department: '', service: 'Post', days: 'Mon-Fri' },
    { name: 'Gary Bromley', type: 'General', shift: '', department: '', service: 'Post', days: 'Mon-Fri' },
    { name: 'Mike Brennan', type: 'General', shift: '', department: '', service: 'Stores', days: 'Mon-Fri' },
    { name: 'Lucy Redfearn', type: 'General', shift: '4 on 4 off', department: '', service: '' },
    { name: 'Mark Dickinson', type: 'General', shift: '', department: '', service: 'District Drivers', days: 'Mon-Fri' },
    { name: 'Paul Berry', type: 'General', shift: '', department: '', service: 'Blood Drivers', days: 'Mon-Fri' },
    { name: 'Robert Frost', type: 'General', shift: '', department: '', service: 'Blood Drivers', days: 'Mon-Fri' },
    { name: 'Andrew Gibson', type: 'General', shift: '', department: '', service: 'Blood Drivers', days: 'Mon-Fri' },
    { name: 'Nigel Beesley', type: 'General', shift: '', department: '', service: 'Blood Drivers', days: 'Mon-Fri' },
    { name: 'Andy Clayton', type: 'General', shift: '', department: '', service: 'Laundry', days: 'Mon-Fri' },
    { name: 'Matthew Rushton', type: 'General', shift: '', department: '', service: '' },
    { name: 'Mark Haughton', type: 'General', shift: '', department: '', service: 'External Waste' },
    { name: 'Graham Brown', type: 'General', shift: '', department: '', service: 'External Waste', days: 'Mon-Fri' },
    { name: 'Chris Huckaby', type: 'General', shift: '', department: '', service: 'Ad-Hoc', days: 'Mon-Fri' },
    { name: 'Jason Newton', type: 'General', shift: '', department: '', service: 'Ad-Hoc', days: 'Mon-Fri' },
    { name: 'Joe Redfearn', type: 'General', shift: '4 on 4 off (Night)', department: '', service: '' },
    { name: 'Paul Flowers', type: 'General', shift: '', department: '', service: 'Laundry', days: 'Mon-Fri' },
    { name: 'Jake Moran', type: 'Relief', shift: '', department: '', service: '' },
    { name: 'Gavin Marsden', type: 'General', shift: '4 on 4 off', department: '', service: 'Patient Transport' },
    { name: 'Andrew Hassall', type: 'General', shift: '4 on 4 off', department: '', service: 'Patient Transport' },
    { name: 'Alan Clark', type: 'General', shift: '4 on 4 off', department: '', service: 'Patient Transport' },
    { name: 'Duane Kulikowski', type: 'General', shift: '', department: 'L/G/F Xray', service: '', days: 'Sat-Sun' },
    { name: 'Craig Butler', type: 'General', shift: '', department: '', service: '', hours: '11:00 - 19:00' },
    { name: 'George Willerton', type: 'Relief', shift: '', department: '', service: '' }
  ];

  const porters = [];
  for (let i = 0; i < porterData.length; i++) {
    const porter = porterData[i];

    // Find department if specified
    let regularDepartmentId = null;
    if (porter.department) {
      const department = departments.find(d => d.name === porter.department);
      if (department) regularDepartmentId = department.id;
    }

    const porterRecord = await prisma.porter.create({
      data: {
        name: porter.name,
        contractType: porter.type === 'Relief' ? 'RELIEF' :
                     porter.shift.includes('4 on 4 off') ? 'SHIFT' : 'FIXED',
        porterType: porter.type === 'Supervisor' ? 'SUPERVISOR' : 'PORTER',
        weeklyMinHours: porter.type === 'Relief' ? 20 : 37,
        contractedHours: porter.type === 'Relief' ? 20 : 37,
        countsTowardsStaffing: porter.type !== 'Relief',
        regularDepartmentId: regularDepartmentId
      }
    });
    porters.push(porterRecord);
  }

  console.log(`✅ Created ${porters.length} porters`);

  // Create allocations for porters assigned to services
  console.log('📋 Creating service allocations...');
  const allocations = [];
  for (let i = 0; i < porterData.length; i++) {
    const porter = porterData[i];
    const porterRecord = porters[i];

    if (porter.service) {
      const service = services.find(s => s.name === porter.service);
      if (service) {
        // Find the department for this service
        const serviceDepartment = departments.find(d => d.id === service.departmentId);
        if (serviceDepartment) {
          const allocation = await prisma.allocation.create({
            data: {
              porterId: porterRecord.id,
              departmentId: serviceDepartment.id,
              serviceId: service.id,
              startDatetime: new Date('2024-01-01T08:00:00Z'),
              endDatetime: null, // Ongoing allocation
              type: porter.type === 'Relief' ? 'RELIEF' : 'REGULAR',
              reason: `Assigned to ${porter.service} service${porter.hours ? ` - ${porter.hours}` : ''}${porter.days ? ` - ${porter.days}` : ''}`
            }
          });
          allocations.push(allocation);
        }
      }
    }
  }

  console.log(`✅ Created ${allocations.length} service allocations`);

  console.log('🎉 Database seeding completed successfully!');
  console.log(`
📊 Summary:
- Services: ${services.length}
- Buildings: ${buildings.length}
- Departments: ${departments.length}
- Porters: ${porters.length}
- Service Allocations: ${allocations.length}
  `);
}

main()
  .catch((e) => {
    console.error('❌ Error during seeding:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
