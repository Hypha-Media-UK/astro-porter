<template>
  <div class="dashboard" style="display: flex; flex-direction: column; gap: var(--space-8);">
    <!-- Modern Header -->
    <div style="display: flex; flex-direction: column; gap: var(--space-4);">
      <div>
        <h1 style="font-size: var(--font-size-3xl); font-weight: var(--font-weight-bold); color: var(--color-text-primary); line-height: var(--line-height-tight);">Dashboard</h1>
        <p style="color: var(--color-text-secondary); margin-top: var(--space-1);">Real-time porter management and coverage overview</p>
      </div>
      <div style="display: flex; align-items: center; gap: var(--space-3); justify-content: space-between;">
        <div style="font-size: var(--font-size-sm); color: var(--color-text-muted);">{{ currentDateTime }}</div>
        <button @click="refreshData" class="btn btn-secondary btn-sm">
          <i class="fas fa-sync-alt"></i>
          Refresh
        </button>
      </div>
    </div>

    <!-- Modern Stats Overview Cards -->
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: var(--space-6);">
      <!-- Total Departments -->
      <div class="stats-card">
        <div style="display: flex; align-items: center; justify-content: space-between;">
          <div>
            <p class="stats-label">Total Departments</p>
            <p class="stats-value">{{ totalDepartments }}</p>
          </div>
          <div class="stats-icon" style="background-color: var(--color-primary-50); color: var(--color-primary-600);">
            <i class="fas fa-sitemap"></i>
          </div>
        </div>
      </div>

      <!-- Fully Staffed -->
      <div class="stats-card">
        <div style="display: flex; align-items: center; justify-content: space-between;">
          <div>
            <p class="stats-label">Fully Staffed</p>
            <p class="stats-value" style="color: var(--color-success-600);">{{ statusCounts.good }}</p>
          </div>
          <div class="stats-icon" style="background-color: var(--color-success-50); color: var(--color-success-600);">
            <i class="fas fa-check-circle"></i>
          </div>
        </div>
      </div>

      <!-- Under-staffed -->
      <div class="stats-card">
        <div style="display: flex; align-items: center; justify-content: space-between;">
          <div>
            <p class="stats-label">Under-staffed</p>
            <p class="stats-value" style="color: var(--color-warning-600);">{{ statusCounts.warning }}</p>
          </div>
          <div class="stats-icon" style="background-color: var(--color-warning-50); color: var(--color-warning-600);">
            <i class="fas fa-exclamation-triangle"></i>
          </div>
        </div>
      </div>

      <!-- Critical -->
      <div class="stats-card">
        <div style="display: flex; align-items: center; justify-content: space-between;">
          <div>
            <p class="stats-label">Critical</p>
            <p class="stats-value" style="color: var(--color-error-600);">{{ statusCounts.critical }}</p>
          </div>
          <div class="stats-icon" style="background-color: var(--color-error-50); color: var(--color-error-600);">
            <i class="fas fa-times-circle"></i>
          </div>
        </div>
      </div>
    </div>

    <!-- Modern Coverage Overview -->
    <div class="card card-elevated">
      <div class="card-header">
        <div style="display: flex; align-items: center; justify-content: space-between;">
          <div>
            <h3 class="card-title">Coverage Overview</h3>
            <p class="card-subtitle">Real-time departmental staffing levels</p>
          </div>
          <div style="display: flex; align-items: center; gap: var(--space-2);">
            <span class="status-badge success">
              <i class="fas fa-circle" style="font-size: var(--font-size-xs);"></i>
              Live Data
            </span>
          </div>
        </div>
      </div>
      <div class="card-body">
        <!-- Modern Time Navigation Tabs -->
        <div class="time-nav" style="margin-bottom: var(--space-8);">
          <nav style="display: flex; gap: var(--space-1);" aria-label="Tabs">
            <button
              v-for="timeView in timeViews"
              :key="timeView.id"
              @click="setTimeView(timeView.id)"
              :class="[
                'time-nav-item',
                { 'active': activeTimeView === timeView.id }
              ]"
            >
              <i :class="timeView.icon" style="margin-right: var(--space-2);"></i>
              {{ timeView.label }}
            </button>
          </nav>
        </div>

        <!-- Coverage Grid -->
        <div v-if="loading" style="display: flex; align-items: center; justify-content: center; padding: var(--space-16);">
          <div style="display: flex; align-items: center; gap: var(--space-3); color: var(--color-text-muted);">
            <i class="fas fa-spinner fa-spin"></i>
            Loading coverage data...
          </div>
        </div>

        <div v-else style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: var(--space-6);">
          <div
            v-for="department in filteredDepartments"
            :key="department.id"
            class="card"
            style="position: relative; overflow: hidden;"
          >
            <!-- Status indicator -->
            <div 
              style="position: absolute; top: 0; left: 0; width: 4px; height: 100%;"
              :style="{ backgroundColor: getStatusColor(department.coverage_status) }"
            ></div>
            
            <div style="padding: var(--space-6);">
              <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: var(--space-4);">
                <div>
                  <h4 style="font-size: var(--font-size-lg); font-weight: var(--font-weight-semibold); color: var(--color-text-primary);">
                    {{ department.name }}
                  </h4>
                  <p style="font-size: var(--font-size-sm); color: var(--color-text-muted);">
                    {{ department.building_name }}
                  </p>
                </div>
                <span 
                  class="status-badge"
                  :class="department.coverage_status"
                >
                  {{ getStatusLabel(department.coverage_status) }}
                </span>
              </div>

              <div style="display: flex; align-items: center; justify-content: space-between;">
                <div style="display: flex; align-items: center; gap: var(--space-4);">
                  <div style="text-align: center;">
                    <div style="font-size: var(--font-size-2xl); font-weight: var(--font-weight-bold); color: var(--color-text-primary);">
                      {{ department.current_porters }}
                    </div>
                    <div style="font-size: var(--font-size-xs); color: var(--color-text-muted); text-transform: uppercase; letter-spacing: 0.05em;">
                      Current
                    </div>
                  </div>
                  <div style="color: var(--color-text-muted);">/</div>
                  <div style="text-align: center;">
                    <div style="font-size: var(--font-size-2xl); font-weight: var(--font-weight-bold); color: var(--color-text-secondary);">
                      {{ department.required_porters }}
                    </div>
                    <div style="font-size: var(--font-size-xs); color: var(--color-text-muted); text-transform: uppercase; letter-spacing: 0.05em;">
                      Required
                    </div>
                  </div>
                </div>
                
                <div style="text-align: right;">
                  <div 
                    style="font-size: var(--font-size-lg); font-weight: var(--font-weight-semibold);"
                    :style="{ color: getStatusColor(department.coverage_status) }"
                  >
                    {{ Math.round(department.coverage_percentage) }}%
                  </div>
                  <div style="font-size: var(--font-size-xs); color: var(--color-text-muted); text-transform: uppercase; letter-spacing: 0.05em;">
                    Coverage
                  </div>
                </div>
              </div>

              <!-- Progress bar -->
              <div style="margin-top: var(--space-4);">
                <div style="width: 100%; height: 6px; background-color: var(--color-neutral-200); border-radius: var(--radius-full); overflow: hidden;">
                  <div 
                    style="height: 100%; transition: width var(--transition-normal); border-radius: var(--radius-full);"
                    :style="{ 
                      width: Math.min(department.coverage_percentage, 100) + '%',
                      backgroundColor: getStatusColor(department.coverage_status)
                    }"
                  ></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'

// Reactive data
const loading = ref(true)
const departments = ref([])
const activeTimeView = ref('current')
const currentDateTime = ref('')

// Time views configuration
const timeViews = [
  { id: 'current', label: 'Current', icon: 'fas fa-clock' },
  { id: 'day', label: 'Day Shift', icon: 'fas fa-sun' },
  { id: 'night', label: 'Night Shift', icon: 'fas fa-moon' },
  { id: 'weekend', label: 'Weekend', icon: 'fas fa-calendar-weekend' }
]

// Computed properties
const totalDepartments = computed(() => departments.value.length)

const statusCounts = computed(() => {
  const counts = { good: 0, warning: 0, critical: 0 }
  departments.value.forEach(dept => {
    if (dept.coverage_status === 'success') counts.good++
    else if (dept.coverage_status === 'warning') counts.warning++
    else if (dept.coverage_status === 'error') counts.critical++
  })
  return counts
})

const filteredDepartments = computed(() => {
  return departments.value.filter(dept => {
    // Filter logic based on activeTimeView
    return true // For now, show all departments
  })
})

// Methods
const refreshData = async () => {
  loading.value = true
  try {
    const response = await fetch('http://localhost:3001/api/coverage')
    const data = await response.json()
    if (data.success) {
      departments.value = data.data
    }
  } catch (error) {
    console.error('Error fetching coverage data:', error)
  } finally {
    loading.value = false
  }
}

const setTimeView = (viewId) => {
  activeTimeView.value = viewId
}

const getStatusColor = (status) => {
  switch (status) {
    case 'success': return 'var(--color-success-500)'
    case 'warning': return 'var(--color-warning-500)'
    case 'error': return 'var(--color-error-500)'
    default: return 'var(--color-neutral-400)'
  }
}

const getStatusLabel = (status) => {
  switch (status) {
    case 'success': return 'Fully Staffed'
    case 'warning': return 'Under-staffed'
    case 'error': return 'Critical'
    default: return 'Unknown'
  }
}

const updateDateTime = () => {
  const now = new Date()
  currentDateTime.value = now.toLocaleString('en-US', {
    weekday: 'short',
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

// Lifecycle
onMounted(() => {
  refreshData()
  updateDateTime()
  
  // Update time every minute
  const timeInterval = setInterval(updateDateTime, 60000)
  
  // Auto-refresh data every 30 seconds
  const dataInterval = setInterval(refreshData, 30000)
  
  // Cleanup intervals on unmount
  onUnmounted(() => {
    clearInterval(timeInterval)
    clearInterval(dataInterval)
  })
})
</script>
