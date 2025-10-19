# Porter Shift Management & Staffing System - Complete Requirements

## Project Overview

A local-first, web-based application for managing porters, their shifts, departmental coverage, and staffing levels across buildings and services. The system is designed for operational use, not HR or authentication.

### Key Goals
- Real-time staffing visibility across buildings/departments/services
- Automatic detection of under-staffed areas
- Dynamic porter reallocation and absence handling
- Capability-based assignment validation
- Complex shift pattern support with configurable hours

## Technical Stack

- **Frontend**: Astro + Vue 3 + Pure CSS
- **Backend**: Express.js + Prisma ORM + Zod validation
- **Database**: MySQL/MariaDB
- **Testing**: Vitest
- **Environment**: Docker + Orbstack with hot reload
- **Architecture**: Local-first, no authentication required

## System Architecture

### Entity Hierarchy
```
Buildings → Departments → Services
```

### Core Entities

#### Buildings
- Top-level organizational units
- Group related departments
- Enable location-based filtering

#### Departments
- Operational areas (Radiology, Theatres, Pathology)
- Define operational schedules and staffing requirements
- Can operate 24/7 or defined hours
- Support overnight periods (20:00-08:00)

#### Services
- Distinct functions within departments
- Examples: Patient Transport, Specimen Collection, Linen Delivery
- Can inherit department schedules or have custom operational hours
- Independent capability requirements

#### Porters
- **Contract Types**: 
  - `shift`: Follow shift rotation patterns
  - `fixed`: Set days/hours per week
  - `relief`: Fill gaps + guaranteed minimum hours
- **Attributes**:
  - `weekly_min_hours`: For relief staff guarantees
  - `counts_towards_staffing`: Boolean flag for supervisors/trainees
  - `regular_department_id`: Home assignment

#### Shifts
- Complex rotation patterns using JSON structure
- Configurable operational hours via system settings
- Support for offset days across teams
- Ground zero reference dates for cycle calculation

### Shift Pattern JSON Structure
```json
[
  { "type": "day", "label": "Day Shift", "duration_days": 4 },
  { "type": "off", "label": "Rest", "duration_days": 4 },
  { "type": "night", "label": "Night Shift", "duration_days": 4 },
  { "type": "off", "label": "Rest", "duration_days": 4 }
]
```

## Key Business Logic

### 1. Coverage Engine
- **Granularity**: Hourly calculations
- **Process**:
  1. Pull department/service operational periods
  2. Calculate required vs available porters per hour
  3. Exclude unavailable porters
  4. Validate capabilities
  5. Generate color-coded alerts (green/yellow/red)

### 2. Capability Management
- **Required vs Preferred**: Departments/services specify both levels
- **Expiry Handling**: Show warnings, don't block allocations
- **Validation**: Check porter capabilities against requirements

### 3. Allocation System
- **Types**: Regular, Temporary, Relief
- **Auto-expiry**: Temporary allocations remove automatically
- **Override Logic**: Temporary allocations override permanent assignments

### 4. Availability Tracking
- **Statuses**: Available, Unavailable, Overtime
- **Reasons**: Sickness, Annual Leave, Training, etc.
- **Priority**: Always overrides scheduled assignments

### 5. Relief Staff Logic
- **Dual Purpose**: Fill gaps + meet guaranteed hours
- **Automatic Tracking**: Weekly hour calculations vs minimums
- **Indicators**: Under-utilized and overtime warnings

## Configuration Settings

### Configurable Shift Times
- Current: Day 08:00-20:00, Night 20:00-08:00
- Stored in `system_settings` table
- Editable via settings screen

### System Settings Examples
```sql
setting_key: "day_shift_start" → setting_value: "08:00"
setting_key: "night_shift_start" → setting_value: "20:00"
setting_key: "enforce_capability_expiry" → setting_value: "false"
```

## Implementation Specifications

### Overnight Period Handling
- **Single Record Approach**: `open_time: "20:00", close_time: "08:00"`
- **Logic**: When `close_time < open_time`, treat as spanning midnight
- **Coverage**: Adjust datetime comparisons for overnight periods

### Service Inheritance
- Services without custom schedules inherit ALL department periods
- Includes operational hours and porter requirements
- Can be overridden selectively

### Relief Hour Tracking
- **Automatic**: Sum allocation hours per week
- **Comparison**: Against `weekly_min_hours` guarantee
- **Alerts**: Under-utilized and overtime warnings

### Capability Expiry
- **Soft Warnings**: Display alerts but allow allocations
- **Audit Trail**: Log expired capability assignments
- **Configurable**: Optional strict enforcement via settings

## Frontend Requirements

### Home Dashboard
- Hierarchical view of buildings → departments → services
- Real-time coverage indicators (green/yellow/red)
- Porter allocation visibility
- Absence and gap highlighting

### Navigation
- Filter by building or day of week
- Tabs: Current day, rest of week, 6-week forecast
- Drag-and-drop porter reassignment

### Configuration Screens
- **Buildings**: Add/edit locations
- **Departments**: Assign to buildings, set schedules, staffing requirements
- **Services**: Define within departments, capability requirements
- **Porters**: Manage records, shifts, capabilities, absences
- **Shifts**: Create patterns, set cycles, ground zero dates
- **Settings**: Configure shift times, system parameters

### UI Design
- Clean, accessible Pure CSS
- Color-coded status indicators
- Consistent spacing and typography
- Tooltips explaining alerts and shortfalls

## Backend API Requirements

### REST Endpoints
- Full CRUD for all entities
- Dynamic coverage calculations
- Real-time staffing reports
- Capability validation endpoints

### Database Schema
- Prisma ORM with MySQL/MariaDB
- Proper relationships and constraints
- Cascading deletes where appropriate
- Migration and seed support

## Testing Strategy

### Vitest Coverage
- **Unit Tests**: Shift calculations, time overlaps, capability matching
- **Integration Tests**: API responses, coverage calculations
- **Business Logic**: Absence handling, allocation scenarios
- **Frontend**: Vue component rendering, dynamic updates

## Development Environment

### Docker Setup
- **3 Containers**: Frontend, Backend, Database
- **Hot Reload**: Code volume mounts
- **Persistence**: Database volume for data retention
- **Orbstack**: Local container management

### Development Workflow
- Automatic migrations on container start
- Seed data for testing
- Container logs for debugging
- Terminal access for database inspection

## Success Criteria

### Functional Requirements
- ✅ Real-time staffing visibility
- ✅ Automatic shortage detection
- ✅ Dynamic porter reallocation
- ✅ Complex shift pattern support
- ✅ Capability-based validation
- ✅ Overnight shift handling
- ✅ Relief staff hour tracking

### Technical Requirements
- ✅ Local Docker environment
- ✅ Hot reload development
- ✅ Comprehensive test coverage
- ✅ Clean, maintainable code
- ✅ Persistent data storage
- ✅ No authentication required

## Next Steps

1. Set up Docker environment with Orbstack
2. Initialize Astro + Vue frontend
3. Create Express.js backend with Prisma
4. Implement database schema and migrations
5. Build core coverage engine
6. Develop frontend dashboard
7. Add configuration screens
8. Implement testing suite
9. Add drag-and-drop functionality
10. Polish UI and add comprehensive validation

## Complete ERD Structure

### Core Relationships
```
Buildings (1)──(∞) Departments
Departments (1)──(∞) Services
Departments (1)──(1) DepartmentSchedules
DepartmentSchedules (1)──(∞) DepartmentSchedulePeriods
Shifts (1)──(∞) Porters
ShiftPatterns (1)──(∞) Shifts
Porters (1)──(∞) Allocations
Departments (1)──(∞) Allocations
Services (1)──(∞) Allocations
Porters (1)──(∞) Availability
Porters (∞)──(∞) Capabilities
Departments (∞)──(∞) Capabilities
Services (∞)──(∞) Capabilities
```

### Entity Attributes

#### Buildings
- `id`, `name`, `location`, `description`, `created_at`, `updated_at`

#### Departments
- `id`, `name`, `building_id`, `schedule_id`, `description`, `is_247`, `created_at`, `updated_at`

#### Services
- `id`, `name`, `department_id`, `description`, `is_active`, `inherits_schedule`, `created_at`, `updated_at`

#### Porters
- `id`, `name`, `contract_type` (shift|fixed|relief), `shift_id`, `weekly_min_hours`, `contracted_hours`
- `regular_department_id`, `porter_type`, `counts_towards_staffing`, `created_at`, `updated_at`

#### Shifts
- `id`, `name`, `pattern_id`, `shift_mode`, `ident`, `days_on`, `days_off`, `offset_days`, `ground_zero`

#### Shift Patterns
- `id`, `name`, `pattern_json`, `description`, `created_at`, `updated_at`

#### Department Schedules
- `id`, `name`, `pattern_id`, `description`, `is_active`, `created_at`, `updated_at`

#### Department Schedule Periods
- `id`, `schedule_id`, `day_of_week`, `open_time`, `close_time`, `required_porters`

#### Capabilities
- `id`, `name`, `description`, `created_at`, `updated_at`

#### Porter Capabilities
- `porter_id`, `capability_id`, `expiry_date`, `created_at`

#### Department Capabilities
- `department_id`, `capability_id`, `required_level` (required|preferred)

#### Service Capabilities
- `service_id`, `capability_id`, `required_level` (required|preferred)

#### Allocations
- `id`, `porter_id`, `department_id`, `service_id`, `start_datetime`, `end_datetime`
- `type` (regular|temporary|relief), `reason`, `created_at`, `updated_at`

#### Availability
- `id`, `porter_id`, `start_datetime`, `end_datetime`, `status`, `reason`, `created_at`, `updated_at`

#### System Settings
- `setting_key`, `setting_value`, `description`, `updated_at`

## Implementation Details

### Coverage Engine Algorithm
```javascript
// Pseudocode for hourly coverage calculation
function calculateCoverage(departmentId, targetDate, targetHour) {
  const department = getDepartment(departmentId);
  const services = getServices(departmentId);

  // Get operational requirements
  const schedule = getScheduleForDate(department, targetDate);
  const requiredPorters = getRequiredPorters(schedule, targetHour);

  // Get available porters
  const allocatedPorters = getAllocatedPorters(departmentId, targetDate, targetHour);
  const availablePorters = filterAvailablePorters(allocatedPorters, targetDate, targetHour);
  const qualifiedPorters = validateCapabilities(availablePorters, department, services);

  return {
    required: requiredPorters,
    available: qualifiedPorters.length,
    shortfall: Math.max(0, requiredPorters - qualifiedPorters.length),
    status: getStatusColor(requiredPorters, qualifiedPorters.length)
  };
}
```

### Shift Calculation Logic
```javascript
// Calculate current shift state for a porter
function getCurrentShiftState(porter, targetDate) {
  const shift = getShift(porter.shift_id);
  const pattern = JSON.parse(shift.pattern_json);

  const daysSinceGroundZero = Math.floor(
    (targetDate - shift.ground_zero) / (1000 * 60 * 60 * 24)
  );

  const totalCycleDays = pattern.reduce((sum, block) => sum + block.duration_days, 0);
  const cyclePosition = (daysSinceGroundZero + shift.offset_days) % totalCycleDays;

  let accumulatedDays = 0;
  for (const block of pattern) {
    if (cyclePosition < accumulatedDays + block.duration_days) {
      return {
        type: block.type,
        label: block.label,
        dayInBlock: cyclePosition - accumulatedDays + 1,
        totalDaysInBlock: block.duration_days
      };
    }
    accumulatedDays += block.duration_days;
  }
}
```

### Relief Hour Tracking Query
```sql
-- Weekly hours calculation for relief porters
SELECT
  p.id,
  p.name,
  p.weekly_min_hours,
  COALESCE(SUM(TIMESTAMPDIFF(HOUR, a.start_datetime, a.end_datetime)), 0) as worked_hours,
  (COALESCE(SUM(TIMESTAMPDIFF(HOUR, a.start_datetime, a.end_datetime)), 0) - p.weekly_min_hours) as variance
FROM porters p
LEFT JOIN allocations a ON p.id = a.porter_id
  AND a.start_datetime >= DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY)
  AND a.start_datetime < DATE_ADD(DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY), INTERVAL 7 DAY)
WHERE p.contract_type = 'relief'
GROUP BY p.id, p.name, p.weekly_min_hours;
```

## User Stories

### Dashboard View
- As a supervisor, I want to see all departments with real-time staffing status
- As a supervisor, I want to identify under-staffed areas immediately
- As a supervisor, I want to see which porters are absent and why
- As a supervisor, I want to forecast staffing for upcoming weeks

### Porter Management
- As a supervisor, I want to temporarily reassign porters between departments
- As a supervisor, I want to record porter absences and availability
- As a supervisor, I want to ensure porters have required capabilities
- As a supervisor, I want to track relief porter hours against guarantees

### Configuration
- As an administrator, I want to configure shift start/end times
- As an administrator, I want to set up department operational schedules
- As an administrator, I want to define capability requirements
- As an administrator, I want to create complex shift patterns

---

*This document serves as the complete reference for the Porter Shift Management system build.*
