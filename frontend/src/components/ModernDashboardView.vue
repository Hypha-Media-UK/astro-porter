<template>
  <div class="dashboard">
    <!-- Stats Overview Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-6">
      <!-- Total Departments -->
      <div class="stats-card">
        <div class="flex items-center">
          <div class="flex-shrink-0">
            <div class="w-8 h-8 bg-primary-100 rounded-lg flex items-center justify-center dark:bg-primary-900">
              <i class="fas fa-sitemap text-primary-600 dark:text-primary-300"></i>
            </div>
          </div>
          <div class="ml-4">
            <p class="stats-label">Total Departments</p>
            <p class="stats-value">{{ totalDepartments }}</p>
          </div>
        </div>
      </div>

      <!-- Fully Staffed -->
      <div class="stats-card">
        <div class="flex items-center">
          <div class="flex-shrink-0">
            <div class="w-8 h-8 bg-green-100 rounded-lg flex items-center justify-center dark:bg-green-900">
              <i class="fas fa-check-circle text-green-600 dark:text-green-300"></i>
            </div>
          </div>
          <div class="ml-4">
            <p class="stats-label">Fully Staffed</p>
            <p class="stats-value text-green-600 dark:text-green-400">{{ statusCounts.good }}</p>
          </div>
        </div>
      </div>

      <!-- Under-staffed -->
      <div class="stats-card">
        <div class="flex items-center">
          <div class="flex-shrink-0">
            <div class="w-8 h-8 bg-yellow-100 rounded-lg flex items-center justify-center dark:bg-yellow-900">
              <i class="fas fa-exclamation-triangle text-yellow-600 dark:text-yellow-300"></i>
            </div>
          </div>
          <div class="ml-4">
            <p class="stats-label">Under-staffed</p>
            <p class="stats-value text-yellow-600 dark:text-yellow-400">{{ statusCounts.warning }}</p>
          </div>
        </div>
      </div>

      <!-- Critical -->
      <div class="stats-card">
        <div class="flex items-center">
          <div class="flex-shrink-0">
            <div class="w-8 h-8 bg-red-100 rounded-lg flex items-center justify-center dark:bg-red-900">
              <i class="fas fa-times-circle text-red-600 dark:text-red-300"></i>
            </div>
          </div>
          <div class="ml-4">
            <p class="stats-label">Critical</p>
            <p class="stats-value text-red-600 dark:text-red-400">{{ statusCounts.critical }}</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Time Navigation -->
    <div class="card mb-6">
      <div class="card-header">
        <h3 class="card-title">Coverage Overview</h3>
        <p class="text-sm text-gray-500 dark:text-gray-400">{{ currentDateTime }}</p>
      </div>
      <div class="card-body">
        <!-- Time Navigation Tabs -->
        <div class="time-nav mb-6">
          <nav class="flex space-x-8" aria-label="Tabs">
            <button
              v-for="timeView in timeViews"
              :key="timeView.id"
              @click="setTimeView(timeView.id)"
              :class="[
                'time-nav-item',
                { 'active': activeTimeView === timeView.id }
              ]"
            >
              {{ timeView.label }}
            </button>
          </nav>
        </div>

        <!-- Time Controls -->
        <div class="mb-6">
          <div v-if="activeTimeView === 'current'" class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
              <label class="form-label">Current Time:</label>
              <div class="flex gap-2">
                <input
                  v-model="selectedDate"
                  type="date"
                  class="form-input"
                />
                <input
                  v-model="selectedTime"
                  type="time"
                  class="form-input"
                />
              </div>
            </div>
            <div>
              <label class="form-label">Building:</label>
              <select v-model="selectedBuilding" class="form-select">
                <option value="">All Buildings</option>
                <option v-for="building in buildings" :key="building.id" :value="building.id">
                  {{ building.name }}
                </option>
              </select>
            </div>
            <div class="flex items-end">
              <button @click="refreshData" class="btn-primary">
                <i class="fas fa-sync-alt mr-2"></i>
                Refresh
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Coverage Grid -->
    <div class="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-6">
      <div
        v-for="department in filteredCoverage"
        :key="department.id"
        :class="[
          'coverage-card',
          `status-${department.status}`
        ]"
      >
        <!-- Department Header -->
        <div class="flex items-center justify-between mb-4">
          <div>
            <h4 class="text-lg font-semibold text-gray-900 dark:text-white">
              {{ department.name }}
            </h4>
            <p class="text-sm text-gray-500 dark:text-gray-400">
              {{ department.building_name }}
            </p>
          </div>
          <div :class="[
            'badge',
            department.status === 'good' ? 'badge-success' :
            department.status === 'warning' ? 'badge-warning' : 'badge-danger'
          ]">
            {{ department.status.toUpperCase() }}
          </div>
        </div>

        <!-- Coverage Stats -->
        <div class="grid grid-cols-3 gap-4 mb-4">
          <div class="text-center">
            <p class="text-2xl font-bold text-gray-900 dark:text-white">{{ department.required }}</p>
            <p class="text-xs text-gray-500 dark:text-gray-400">Required</p>
          </div>
          <div class="text-center">
            <p class="text-2xl font-bold text-gray-900 dark:text-white">{{ department.available }}</p>
            <p class="text-xs text-gray-500 dark:text-gray-400">Available</p>
          </div>
          <div class="text-center">
            <p :class="[
              'text-2xl font-bold',
              department.shortfall > 0 ? 'text-red-600 dark:text-red-400' : 'text-green-600 dark:text-green-400'
            ]">
              {{ department.shortfall > 0 ? `-${department.shortfall}` : '✓' }}
            </p>
            <p class="text-xs text-gray-500 dark:text-gray-400">Shortfall</p>
          </div>
        </div>

        <!-- Available Porters -->
        <div v-if="department.availablePorters && department.availablePorters.length > 0" class="mb-4">
          <h6 class="text-sm font-medium text-gray-900 dark:text-white mb-2">Available Porters</h6>
          <div class="space-y-2">
            <div
              v-for="porter in department.availablePorters"
              :key="porter.id"
              class="porter-item"
              draggable="true"
              @dragstart="onPorterDragStart($event, porter, department.id)"
              @dragend="onPorterDragEnd"
            >
              <div class="flex items-center">
                <div class="w-8 h-8 bg-primary-100 rounded-full flex items-center justify-center mr-3 dark:bg-primary-900">
                  <i class="fas fa-user text-primary-600 text-sm dark:text-primary-300"></i>
                </div>
                <div>
                  <p class="text-sm font-medium text-gray-900 dark:text-white">{{ porter.name }}</p>
                  <p class="text-xs text-gray-500 dark:text-gray-400">{{ getPorterStatusText(porter) }}</p>
                </div>
              </div>
              <div v-if="porter.capabilityMatch" class="badge badge-success">
                <i class="fas fa-check mr-1"></i> Qualified
              </div>
            </div>
          </div>
        </div>

        <!-- Drop Zone -->
        <div
          class="drop-zone"
          :class="{ 'drop-zone-active': isDragOver }"
          @dragover.prevent="onDragOver"
          @dragleave="onDragLeave"
          @drop="onPorterDrop($event, department.id)"
        >
          <i class="fas fa-user-plus mb-1"></i>
          <span class="text-sm">Drop porter here to assign</span>
        </div>
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="flex items-center justify-center py-12">
      <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-600"></div>
      <span class="ml-3 text-gray-600 dark:text-gray-400">Loading coverage data...</span>
    </div>

    <!-- Empty State -->
    <div v-if="!loading && filteredCoverage.length === 0" class="text-center py-12">
      <i class="fas fa-chart-bar text-4xl text-gray-400 mb-4"></i>
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">No coverage data available</h3>
      <p class="text-gray-500 dark:text-gray-400">Check your filters or refresh the data.</p>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'

// Reactive data
const loading = ref(false)
const coverage = ref([])
const buildings = ref([])
const selectedDate = ref('')
const selectedTime = ref('')
const selectedBuilding = ref('')
const activeTimeView = ref('current')
const isDragOver = ref(false)
const draggedPorter = ref(null)
const draggedFromDepartment = ref(null)

// Time views
const timeViews = [
  { id: 'current', label: 'Current Day' },
  { id: 'week', label: 'Rest of Week' },
  { id: 'forecast', label: '6-Week Forecast' }
]

// Auto-refresh interval
let refreshInterval = null

// Current date time as a ref to avoid hydration mismatch
const currentDateTime = ref('Loading...')

// Function to update current date time
const updateCurrentDateTime = () => {
  const now = new Date()
  currentDateTime.value = now.toLocaleString('en-GB', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

const totalDepartments = computed(() => coverage.value.length)

const statusCounts = computed(() => {
  return coverage.value.reduce((counts, dept) => {
    counts[dept.status] = (counts[dept.status] || 0) + 1
    return counts
  }, { good: 0, warning: 0, critical: 0 })
})

const filteredCoverage = computed(() => {
  if (!selectedBuilding.value) return coverage.value
  return coverage.value.filter(dept => dept.building_id === selectedBuilding.value)
})

// Methods
const setTimeView = (viewId) => {
  activeTimeView.value = viewId
}

const fetchCoverageData = async () => {
  loading.value = true
  try {
    const params = new URLSearchParams({
      date: selectedDate.value,
      hour: selectedTime.value.split(':')[0]
    })
    
    if (selectedBuilding.value) {
      params.append('building_id', selectedBuilding.value)
    }

    const response = await fetch(`http://localhost:3001/api/coverage/departments?${params}`)
    if (response.ok) {
      const data = await response.json()
      coverage.value = data.data || []
    }
  } catch (error) {
    console.error('Error fetching coverage data:', error)
  } finally {
    loading.value = false
  }
}

const fetchBuildings = async () => {
  try {
    const response = await fetch('http://localhost:3001/api/buildings')
    if (response.ok) {
      const data = await response.json()
      buildings.value = data.data || []
    }
  } catch (error) {
    console.error('Error fetching buildings:', error)
  }
}

const refreshData = () => {
  fetchCoverageData()
}

// Drag and drop methods
const onPorterDragStart = (event, porter, departmentId) => {
  draggedPorter.value = porter
  draggedFromDepartment.value = departmentId
  event.dataTransfer.effectAllowed = 'move'
  event.dataTransfer.setData('text/plain', porter.id)
  event.target.classList.add('dragging')
}

const onPorterDragEnd = (event) => {
  event.target.classList.remove('dragging')
  draggedPorter.value = null
  draggedFromDepartment.value = null
}

const onDragOver = (event) => {
  event.preventDefault()
  isDragOver.value = true
}

const onDragLeave = () => {
  isDragOver.value = false
}

const onPorterDrop = async (event, toDepartmentId) => {
  event.preventDefault()
  isDragOver.value = false
  
  if (!draggedPorter.value || draggedFromDepartment.value === toDepartmentId) {
    return
  }
  
  try {
    const allocationData = {
      porter_id: draggedPorter.value.id,
      department_id: toDepartmentId,
      start_datetime: new Date().toISOString(),
      type: 'TEMPORARY',
      reason: `Reassigned via drag-and-drop from dashboard`
    }
    
    const response = await fetch('http://localhost:3001/api/allocations', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(allocationData)
    })
    
    if (response.ok) {
      await fetchCoverageData()
      console.log(`Porter ${draggedPorter.value.name} reassigned to department ${toDepartmentId}`)
    } else {
      const error = await response.json()
      alert(`Failed to reassign porter: ${error.error || 'Unknown error'}`)
    }
  } catch (error) {
    console.error('Error reassigning porter:', error)
    alert('Failed to reassign porter')
  }
}

const getPorterStatusText = (porter) => {
  if (porter.availability === 'UNAVAILABLE') return 'Unavailable'
  if (porter.availability === 'OVERTIME') return 'Overtime'
  return 'Available'
}

// Lifecycle
onMounted(() => {
  // Initialize current date time on client side to avoid hydration mismatch
  updateCurrentDateTime()

  // Initialize date/time values on client-side to avoid hydration mismatch
  const now = new Date()
  selectedDate.value = now.toISOString().split('T')[0]
  selectedTime.value = now.toTimeString().slice(0, 5)

  fetchBuildings()
  fetchCoverageData()

  // Set up auto-refresh every 5 minutes
  refreshInterval = setInterval(() => {
    fetchCoverageData()
    updateCurrentDateTime() // Also update the time display
  }, 5 * 60 * 1000)
})

onUnmounted(() => {
  if (refreshInterval) {
    clearInterval(refreshInterval)
  }
})
</script>
