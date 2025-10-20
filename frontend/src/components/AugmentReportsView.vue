<template>
  <div style="display: flex; flex-direction: column; gap: var(--space-8);">
    <!-- Header -->
    <div>
      <h1 style="font-size: var(--font-size-3xl); font-weight: var(--font-weight-bold); color: var(--color-text-primary); line-height: var(--line-height-tight);">Reports</h1>
      <p style="color: var(--color-text-secondary); margin-top: var(--space-1);">Analytics and reporting for porter management and staffing</p>
    </div>

    <!-- Report Categories -->
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: var(--space-6);">
      <!-- Staffing Reports -->
      <div class="card card-elevated">
        <div style="padding: var(--space-6);">
          <div style="display: flex; align-items: center; gap: var(--space-3); margin-bottom: var(--space-4);">
            <div style="width: 48px; height: 48px; background-color: var(--color-primary-50); color: var(--color-primary-600); border-radius: var(--radius-xl); display: flex; align-items: center; justify-content: center;">
              <i class="fas fa-users" style="font-size: var(--font-size-lg);"></i>
            </div>
            <div>
              <h3 style="font-size: var(--font-size-lg); font-weight: var(--font-weight-semibold); color: var(--color-text-primary);">Staffing Reports</h3>
              <p style="font-size: var(--font-size-sm); color: var(--color-text-muted);">Porter allocation and coverage analysis</p>
            </div>
          </div>
          
          <div style="display: flex; flex-direction: column; gap: var(--space-3);">
            <button class="btn btn-ghost" style="justify-content: flex-start;">
              <i class="fas fa-chart-line"></i>
              Coverage Trends
            </button>
            <button class="btn btn-ghost" style="justify-content: flex-start;">
              <i class="fas fa-clock"></i>
              Shift Patterns
            </button>
            <button class="btn btn-ghost" style="justify-content: flex-start;">
              <i class="fas fa-exclamation-triangle"></i>
              Understaffing Alerts
            </button>
          </div>
        </div>
      </div>

      <!-- Performance Reports -->
      <div class="card card-elevated">
        <div style="padding: var(--space-6);">
          <div style="display: flex; align-items: center; gap: var(--space-3); margin-bottom: var(--space-4);">
            <div style="width: 48px; height: 48px; background-color: var(--color-success-50); color: var(--color-success-600); border-radius: var(--radius-xl); display: flex; align-items: center; justify-content: center;">
              <i class="fas fa-chart-bar" style="font-size: var(--font-size-lg);"></i>
            </div>
            <div>
              <h3 style="font-size: var(--font-size-lg); font-weight: var(--font-weight-semibold); color: var(--color-text-primary);">Performance Reports</h3>
              <p style="font-size: var(--font-size-sm); color: var(--color-text-muted);">Efficiency and productivity metrics</p>
            </div>
          </div>
          
          <div style="display: flex; flex-direction: column; gap: var(--space-3);">
            <button class="btn btn-ghost" style="justify-content: flex-start;">
              <i class="fas fa-tachometer-alt"></i>
              Department Efficiency
            </button>
            <button class="btn btn-ghost" style="justify-content: flex-start;">
              <i class="fas fa-user-check"></i>
              Porter Performance
            </button>
            <button class="btn btn-ghost" style="justify-content: flex-start;">
              <i class="fas fa-calendar-check"></i>
              Attendance Tracking
            </button>
          </div>
        </div>
      </div>

      <!-- Operational Reports -->
      <div class="card card-elevated">
        <div style="padding: var(--space-6);">
          <div style="display: flex; align-items: center; gap: var(--space-3); margin-bottom: var(--space-4);">
            <div style="width: 48px; height: 48px; background-color: var(--color-warning-50); color: var(--color-warning-600); border-radius: var(--radius-xl); display: flex; align-items: center; justify-content: center;">
              <i class="fas fa-cogs" style="font-size: var(--font-size-lg);"></i>
            </div>
            <div>
              <h3 style="font-size: var(--font-size-lg); font-weight: var(--font-weight-semibold); color: var(--color-text-primary);">Operational Reports</h3>
              <p style="font-size: var(--font-size-sm); color: var(--color-text-muted);">System usage and operational insights</p>
            </div>
          </div>
          
          <div style="display: flex; flex-direction: column; gap: var(--space-3);">
            <button class="btn btn-ghost" style="justify-content: flex-start;">
              <i class="fas fa-building"></i>
              Building Utilization
            </button>
            <button class="btn btn-ghost" style="justify-content: flex-start;">
              <i class="fas fa-concierge-bell"></i>
              Service Requests
            </button>
            <button class="btn btn-ghost" style="justify-content: flex-start;">
              <i class="fas fa-calendar-alt"></i>
              Schedule Compliance
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Quick Stats -->
    <div class="card card-elevated">
      <div class="card-header">
        <h3 class="card-title">Quick Statistics</h3>
        <p class="card-subtitle">Overview of key metrics for the current period</p>
      </div>
      <div class="card-body">
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: var(--space-6);">
          <div style="text-align: center;">
            <div style="font-size: var(--font-size-3xl); font-weight: var(--font-weight-bold); color: var(--color-primary-600);">
              {{ stats.totalPorters }}
            </div>
            <div style="font-size: var(--font-size-sm); color: var(--color-text-muted); text-transform: uppercase; letter-spacing: 0.05em;">
              Total Porters
            </div>
          </div>
          
          <div style="text-align: center;">
            <div style="font-size: var(--font-size-3xl); font-weight: var(--font-weight-bold); color: var(--color-success-600);">
              {{ stats.averageCoverage }}%
            </div>
            <div style="font-size: var(--font-size-sm); color: var(--color-text-muted); text-transform: uppercase; letter-spacing: 0.05em;">
              Average Coverage
            </div>
          </div>
          
          <div style="text-align: center;">
            <div style="font-size: var(--font-size-3xl); font-weight: var(--font-weight-bold); color: var(--color-warning-600);">
              {{ stats.activeShifts }}
            </div>
            <div style="font-size: var(--font-size-sm); color: var(--color-text-muted); text-transform: uppercase; letter-spacing: 0.05em;">
              Active Shifts
            </div>
          </div>
          
          <div style="text-align: center;">
            <div style="font-size: var(--font-size-3xl); font-weight: var(--font-weight-bold); color: var(--color-error-600);">
              {{ stats.criticalDepartments }}
            </div>
            <div style="font-size: var(--font-size-sm); color: var(--color-text-muted); text-transform: uppercase; letter-spacing: 0.05em;">
              Critical Departments
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Recent Activity -->
    <div class="card card-elevated">
      <div class="card-header">
        <h3 class="card-title">Recent Activity</h3>
        <p class="card-subtitle">Latest system events and changes</p>
      </div>
      <div class="card-body">
        <div style="display: flex; flex-direction: column; gap: var(--space-4);">
          <div v-for="activity in recentActivity" :key="activity.id" style="display: flex; align-items: center; gap: var(--space-4); padding: var(--space-3); border-radius: var(--radius-lg); background-color: var(--color-surface);">
            <div style="width: 40px; height: 40px; border-radius: var(--radius-full); display: flex; align-items: center; justify-content: center;" :style="{ backgroundColor: activity.color + '20', color: activity.color }">
              <i :class="activity.icon"></i>
            </div>
            <div style="flex: 1;">
              <div style="font-weight: var(--font-weight-medium); color: var(--color-text-primary);">
                {{ activity.title }}
              </div>
              <div style="font-size: var(--font-size-sm); color: var(--color-text-muted);">
                {{ activity.description }}
              </div>
            </div>
            <div style="font-size: var(--font-size-xs); color: var(--color-text-muted);">
              {{ activity.time }}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

// Reactive data
const stats = ref({
  totalPorters: 0,
  averageCoverage: 0,
  activeShifts: 0,
  criticalDepartments: 0
})

const recentActivity = ref([
  {
    id: 1,
    title: 'New Porter Added',
    description: 'John Smith assigned to Emergency Department',
    time: '2 hours ago',
    icon: 'fas fa-user-plus',
    color: 'var(--color-success-500)'
  },
  {
    id: 2,
    title: 'Coverage Alert',
    description: 'ICU department below minimum staffing',
    time: '4 hours ago',
    icon: 'fas fa-exclamation-triangle',
    color: 'var(--color-warning-500)'
  },
  {
    id: 3,
    title: 'Shift Pattern Updated',
    description: 'Night shift schedule modified for Building A',
    time: '6 hours ago',
    icon: 'fas fa-clock',
    color: 'var(--color-primary-500)'
  },
  {
    id: 4,
    title: 'Department Created',
    description: 'New Radiology department added to Building B',
    time: '1 day ago',
    icon: 'fas fa-sitemap',
    color: 'var(--color-info-500)'
  }
])

// Methods
const fetchStats = async () => {
  try {
    // Fetch porter count
    const portersResponse = await fetch('http://localhost:3001/api/porters')
    const portersData = await portersResponse.json()
    if (portersData.success) {
      stats.value.totalPorters = portersData.data.length
    }

    // Fetch coverage data
    const coverageResponse = await fetch('http://localhost:3001/api/coverage')
    const coverageData = await coverageResponse.json()
    if (coverageData.success) {
      const departments = coverageData.data
      const totalCoverage = departments.reduce((sum, dept) => sum + dept.coverage_percentage, 0)
      stats.value.averageCoverage = Math.round(totalCoverage / departments.length)
      stats.value.criticalDepartments = departments.filter(dept => dept.coverage_status === 'error').length
    }

    // Mock active shifts for now
    stats.value.activeShifts = 24
  } catch (error) {
    console.error('Error fetching stats:', error)
  }
}

// Lifecycle
onMounted(() => {
  fetchStats()
})
</script>
