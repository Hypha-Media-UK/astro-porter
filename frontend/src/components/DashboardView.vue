<template>
  <div class="dashboard">
    <!-- Header with Real-time Status -->
    <div class="dashboard-header mb-4">
      <div class="d-flex align-items-center justify-content-between">
        <div>
          <h2>Staffing Dashboard</h2>
          <p class="text-muted mb-0">{{ currentDateTime }}</p>
        </div>
        <div class="status-summary">
          <div class="d-flex gap-3">
            <div class="status-item">
              <span class="badge badge-success">{{ statusCounts.good }}</span>
              <small>Fully Staffed</small>
            </div>
            <div class="status-item">
              <span class="badge badge-warning">{{ statusCounts.warning }}</span>
              <small>Under-staffed</small>
            </div>
            <div class="status-item">
              <span class="badge badge-danger">{{ statusCounts.critical }}</span>
              <small>Critical</small>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Time Navigation Tabs -->
    <div class="time-navigation mb-4">
      <div class="nav nav-tabs" role="tablist">
        <button
          v-for="timeView in timeViews"
          :key="timeView.id"
          @click="setTimeView(timeView.id)"
          :class="['nav-link', { active: activeTimeView === timeView.id }]"
        >
          {{ timeView.label }}
        </button>
      </div>

      <!-- Time View Content -->
      <div class="tab-content mt-3">
        <!-- Current Day View -->
        <div v-if="activeTimeView === 'current'" class="time-controls">
          <div class="row align-items-end">
            <div class="col-md-4">
              <label class="form-label">Current Time:</label>
              <div class="d-flex gap-2">
                <input
                  type="date"
                  v-model="selectedDate"
                  class="form-control"
                  @change="fetchCoverageData"
                />
                <input
                  type="time"
                  v-model="selectedTime"
                  class="form-control"
                  @change="fetchCoverageData"
                />
              </div>
            </div>
            <div class="col-md-4">
              <label class="form-label">Building Filter:</label>
              <select v-model="selectedBuilding" class="form-control" @change="filterDepartments">
                <option value="">All Buildings</option>
                <option v-for="building in buildings" :key="building.id" :value="building.id">
                  {{ building.name }}
                </option>
              </select>
            </div>
            <div class="col-md-4">
              <button @click="setToCurrentTime" class="btn btn-outline-primary">
                <i class="fas fa-clock"></i> Now
              </button>
              <button @click="fetchCoverageData" class="btn btn-primary ms-2">
                <i class="fas fa-refresh"></i> Refresh
              </button>
            </div>
          </div>
        </div>

        <!-- Week View -->
        <div v-if="activeTimeView === 'week'" class="time-controls">
          <div class="row align-items-end">
            <div class="col-md-4">
              <label class="form-label">Week Starting:</label>
              <input
                type="date"
                v-model="weekStartDate"
                class="form-control"
                @change="fetchWeekData"
              />
            </div>
            <div class="col-md-4">
              <label class="form-label">Building Filter:</label>
              <select v-model="selectedBuilding" class="form-control" @change="filterDepartments">
                <option value="">All Buildings</option>
                <option v-for="building in buildings" :key="building.id" :value="building.id">
                  {{ building.name }}
                </option>
              </select>
            </div>
            <div class="col-md-4">
              <button @click="setToCurrentWeek" class="btn btn-outline-primary">
                <i class="fas fa-calendar-week"></i> This Week
              </button>
              <button @click="fetchWeekData" class="btn btn-primary ms-2">
                <i class="fas fa-refresh"></i> Refresh
              </button>
            </div>
          </div>
        </div>

        <!-- 6-Week Forecast -->
        <div v-if="activeTimeView === 'forecast'" class="time-controls">
          <div class="row align-items-end">
            <div class="col-md-4">
              <label class="form-label">Forecast From:</label>
              <input
                type="date"
                v-model="forecastStartDate"
                class="form-control"
                @change="fetchForecastData"
              />
            </div>
            <div class="col-md-4">
              <label class="form-label">Building Filter:</label>
              <select v-model="selectedBuilding" class="form-control" @change="filterDepartments">
                <option value="">All Buildings</option>
                <option v-for="building in buildings" :key="building.id" :value="building.id">
                  {{ building.name }}
                </option>
              </select>
            </div>
            <div class="col-md-4">
              <button @click="setToCurrentForecast" class="btn btn-outline-primary">
                <i class="fas fa-chart-line"></i> From Today
              </button>
              <button @click="fetchForecastData" class="btn btn-primary ms-2">
                <i class="fas fa-refresh"></i> Refresh
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="text-center py-4">
      <div class="spinner-border" role="status">
        <span class="visually-hidden">Loading...</span>
      </div>
      <p class="mt-2">Loading coverage data...</p>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="alert alert-danger">
      <h5>Error Loading Data</h5>
      <p>{{ error }}</p>
      <button @click="fetchCoverageData" class="btn btn-primary">Retry</button>
    </div>

    <!-- Coverage Data -->
    <div v-else class="coverage-data">
      <!-- Department Coverage Cards -->
      <div class="row">
        <div v-for="department in filteredDepartments" :key="department.id" class="col-lg-6 col-xl-4 mb-4">
          <div class="card department-card" :class="getDepartmentCardClass(department)">
            <div class="card-header d-flex justify-content-between align-items-center">
              <div>
                <h5 class="mb-0">{{ department.name }}</h5>
                <small class="text-muted">{{ department.building }}</small>
              </div>
              <div class="status-badge">
                <span class="badge" :class="getStatusBadgeClass(department.status)">
                  {{ getStatusText(department.status) }}
                </span>
              </div>
            </div>
            <div class="card-body">
              <div v-if="!department.operational" class="text-center text-muted py-3">
                <i class="fas fa-moon"></i>
                <p class="mb-0">Department Closed</p>
                <small>{{ department.is247 ? 'Overnight hours' : 'Outside operational hours' }}</small>
              </div>
              <div v-else>
                <!-- Staffing Numbers -->
                <div class="staffing-overview mb-3">
                  <div class="row text-center">
                    <div class="col-4">
                      <div class="metric">
                        <div class="metric-value text-primary">{{ department.required }}</div>
                        <div class="metric-label">Required</div>
                      </div>
                    </div>
                    <div class="col-4">
                      <div class="metric">
                        <div class="metric-value text-success">{{ department.available }}</div>
                        <div class="metric-label">Available</div>
                      </div>
                    </div>
                    <div class="col-4">
                      <div class="metric">
                        <div class="metric-value text-danger">{{ department.shortfall }}</div>
                        <div class="metric-label">Shortfall</div>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- Coverage Progress Bar -->
                <div class="coverage-progress mb-3">
                  <div class="d-flex justify-content-between align-items-center mb-1">
                    <small>Coverage Level</small>
                    <small>{{ getCoveragePercentage(department) }}%</small>
                  </div>
                  <div class="progress">
                    <div
                      class="progress-bar"
                      :class="getProgressBarClass(department.status)"
                      :style="{ width: getCoveragePercentage(department) + '%' }"
                    ></div>
                  </div>
                </div>

                <!-- Available Porters (Drag & Drop) -->
                <div v-if="department.availablePorters && department.availablePorters.length > 0" class="available-porters mb-3">
                  <h6 class="mb-2">Available Porters</h6>
                  <div class="porter-list">
                    <div
                      v-for="porter in department.availablePorters"
                      :key="porter.id"
                      class="porter-item"
                      :class="{ 'porter-unavailable': porter.availabilityStatus === 'UNAVAILABLE' }"
                      draggable="true"
                      @dragstart="onPorterDragStart($event, porter, department.id)"
                      @dragend="onPorterDragEnd"
                    >
                      <div class="porter-info">
                        <span class="porter-name">{{ porter.name }}</span>
                        <span class="porter-status" :class="getPorterStatusClass(porter)">
                          {{ getPorterStatusText(porter) }}
                        </span>
                      </div>
                      <div class="porter-capabilities">
                        <span v-if="porter.capabilityMatch" class="capability-badge badge-success">
                          <i class="fas fa-check"></i> Qualified
                        </span>
                        <span v-else class="capability-badge badge-warning">
                          <i class="fas fa-exclamation-triangle"></i> Missing Skills
                        </span>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- Drop Zone for Porter Reassignment -->
                <div
                  class="drop-zone"
                  :class="{ 'drop-zone-active': isDragOver }"
                  @dragover.prevent="onDragOver"
                  @dragleave="onDragLeave"
                  @drop="onPorterDrop($event, department.id)"
                >
                  <i class="fas fa-user-plus"></i>
                  <span>Drop porter here to assign</span>
                </div>

                <!-- Quick Actions -->
                <div class="quick-actions">
                  <button
                    class="btn btn-sm btn-outline-primary"
                    @click="viewDepartmentDetails(department.id)"
                  >
                    View Details
                  </button>
                  <button
                    v-if="department.shortfall > 0"
                    class="btn btn-sm btn-outline-warning"
                    @click="requestCover(department.id)"
                  >
                    Request Cover
                  </button>
                  <button
                    class="btn btn-sm btn-outline-info"
                    @click="showPorterAllocation(department.id)"
                  >
                    Manage Allocation
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- No Data State -->
      <div v-if="filteredDepartments.length === 0" class="text-center py-5">
        <i class="fas fa-building fa-3x text-muted mb-3"></i>
        <h4>No Departments Found</h4>
        <p class="text-muted">
          {{ selectedBuilding ? 'No departments in selected building' : 'No departments configured' }}
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue';

// Reactive data
const loading = ref(true);
const error = ref(null);
const buildings = ref([]);
const departments = ref([]);
const selectedBuilding = ref('');
const selectedDate = ref(new Date().toISOString().split('T')[0]);
const selectedTime = ref(new Date().toTimeString().slice(0, 5));
const currentDateTime = ref('');

// Time navigation
const activeTimeView = ref('current');
const weekStartDate = ref(getWeekStart(new Date()).toISOString().split('T')[0]);
const forecastStartDate = ref(new Date().toISOString().split('T')[0]);

const timeViews = [
  { id: 'current', label: 'Current Day' },
  { id: 'week', label: 'Rest of Week' },
  { id: 'forecast', label: '6-Week Forecast' }
];

// Drag and drop
const isDragOver = ref(false);
const draggedPorter = ref(null);
const draggedFromDepartment = ref(null);

// Computed properties
const filteredDepartments = computed(() => {
  if (!selectedBuilding.value) {
    return departments.value;
  }
  return departments.value.filter(dept => dept.building === selectedBuilding.value);
});

const statusCounts = computed(() => {
  const counts = { good: 0, warning: 0, critical: 0 };
  departments.value.forEach(dept => {
    if (dept.operational) {
      counts[dept.status] = (counts[dept.status] || 0) + 1;
    }
  });
  return counts;
});

// Helper functions
function getWeekStart(date) {
  const d = new Date(date);
  const day = d.getDay();
  const diff = d.getDate() - day + (day === 0 ? -6 : 1); // Adjust when day is Sunday
  return new Date(d.setDate(diff));
}

// Methods
const updateDateTime = () => {
  const now = new Date();
  currentDateTime.value = now.toLocaleString('en-GB', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  });
};

// Time navigation methods
const setTimeView = (viewId) => {
  activeTimeView.value = viewId;
  switch (viewId) {
    case 'current':
      fetchCoverageData();
      break;
    case 'week':
      fetchWeekData();
      break;
    case 'forecast':
      fetchForecastData();
      break;
  }
};

const setToCurrentTime = () => {
  const now = new Date();
  selectedDate.value = now.toISOString().split('T')[0];
  selectedTime.value = now.toTimeString().slice(0, 5);
  fetchCoverageData();
};

const setToCurrentWeek = () => {
  weekStartDate.value = getWeekStart(new Date()).toISOString().split('T')[0];
  fetchWeekData();
};

const setToCurrentForecast = () => {
  forecastStartDate.value = new Date().toISOString().split('T')[0];
  fetchForecastData();
};

const fetchWeekData = async () => {
  // For now, use the same endpoint but could be enhanced for week view
  await fetchCoverageData();
};

const fetchForecastData = async () => {
  // For now, use the same endpoint but could be enhanced for forecast view
  await fetchCoverageData();
};

const fetchCoverageData = async () => {
  try {
    loading.value = true;
    error.value = null;

    const targetDate = selectedDate.value;
    const targetHour = parseInt(selectedTime.value.split(':')[0]);

    const response = await fetch(`http://localhost:3001/api/coverage/departments?date=${targetDate}&hour=${targetHour}`);
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const result = await response.json();
    if (result.success) {
      departments.value = result.data;

      // Also fetch buildings for filter
      const buildingsResponse = await fetch('http://localhost:3001/api/buildings');
      if (buildingsResponse.ok) {
        const buildingsResult = await buildingsResponse.json();
        if (buildingsResult.success) {
          buildings.value = buildingsResult.data;
        }
      }
    } else {
      throw new Error(result.error || 'Failed to fetch coverage data');
    }
  } catch (err) {
    console.error('Failed to fetch coverage data:', err);
    error.value = err.message;
    
  } finally {
    loading.value = false;
  }
};

const filterDepartments = () => {
  // Trigger reactive update when building filter changes
};

const viewDepartmentDetails = (departmentId) => {
  // TODO: Navigate to department detail view or show modal
  console.log('View details for department:', departmentId);
};

const requestCover = (departmentId) => {
  // TODO: Open cover request modal or navigate to allocation page
  console.log('Request cover for department:', departmentId);
};

// Porter status methods
const getPorterStatusClass = (porter) => {
  if (porter.availabilityStatus === 'UNAVAILABLE') return 'status-unavailable';
  if (porter.availabilityStatus === 'OVERTIME') return 'status-overtime';
  return 'status-available';
};

const getPorterStatusText = (porter) => {
  switch (porter.availabilityStatus) {
    case 'UNAVAILABLE': return 'Unavailable';
    case 'OVERTIME': return 'Overtime';
    case 'AVAILABLE':
    default: return 'Available';
  }
};

// Drag and drop methods
const onPorterDragStart = (event, porter, departmentId) => {
  draggedPorter.value = porter;
  draggedFromDepartment.value = departmentId;
  event.dataTransfer.effectAllowed = 'move';
  event.dataTransfer.setData('text/plain', porter.id);

  // Add visual feedback
  event.target.classList.add('dragging');
};

const onPorterDragEnd = (event) => {
  event.target.classList.remove('dragging');
  draggedPorter.value = null;
  draggedFromDepartment.value = null;
};

const onDragOver = (event) => {
  event.preventDefault();
  isDragOver.value = true;
  event.dataTransfer.dropEffect = 'move';
};

const onDragLeave = () => {
  isDragOver.value = false;
};

const onPorterDrop = async (event, toDepartmentId) => {
  event.preventDefault();
  isDragOver.value = false;

  if (!draggedPorter.value || draggedFromDepartment.value === toDepartmentId) {
    return;
  }

  try {
    // Create a temporary allocation
    const allocationData = {
      porter_id: draggedPorter.value.id,
      department_id: toDepartmentId,
      start_datetime: new Date().toISOString(),
      type: 'TEMPORARY',
      reason: `Reassigned via drag-and-drop from dashboard`
    };

    const response = await fetch('http://localhost:3001/api/allocations', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(allocationData)
    });

    if (response.ok) {
      // Refresh coverage data to show the change
      await fetchCoverageData();
      console.log(`Porter ${draggedPorter.value.name} reassigned to department ${toDepartmentId}`);
    } else {
      const error = await response.json();
      alert(`Failed to reassign porter: ${error.error || 'Unknown error'}`);
    }
  } catch (error) {
    console.error('Error reassigning porter:', error);
    alert('Failed to reassign porter');
  }
};

const showPorterAllocation = (departmentId) => {
  console.log('Show porter allocation for department:', departmentId);
  // TODO: Open allocation management modal
};

// Helper functions for status display
const getDepartmentCardClass = (department) => {
  if (!department.operational) return 'border-secondary';

  switch (department.status) {
    case 'good': return 'border-success';
    case 'warning': return 'border-warning';
    case 'critical': return 'border-danger';
    default: return 'border-secondary';
  }
};

const getStatusBadgeClass = (status) => {
  switch (status) {
    case 'good': return 'badge-success';
    case 'warning': return 'badge-warning';
    case 'critical': return 'badge-danger';
    case 'closed': return 'badge-secondary';
    default: return 'badge-secondary';
  }
};

const getStatusText = (status) => {
  switch (status) {
    case 'good': return 'Fully Staffed';
    case 'warning': return 'Under-staffed';
    case 'critical': return 'Critical';
    case 'closed': return 'Closed';
    default: return 'Unknown';
  }
};

const getProgressBarClass = (status) => {
  switch (status) {
    case 'good': return 'bg-success';
    case 'warning': return 'bg-warning';
    case 'critical': return 'bg-danger';
    default: return 'bg-secondary';
  }
};

const getCoveragePercentage = (department) => {
  if (!department.operational || department.required === 0) return 0;
  return Math.min(100, Math.round((department.available / department.required) * 100));
};

// Lifecycle
onMounted(() => {
  updateDateTime();
  fetchCoverageData();

  // Update time every minute
  const timeInterval = setInterval(updateDateTime, 60000);

  // Auto-refresh coverage data every 5 minutes
  const dataInterval = setInterval(fetchCoverageData, 5 * 60 * 1000);

  // Cleanup on unmount
  onUnmounted(() => {
    clearInterval(timeInterval);
    clearInterval(dataInterval);
  });
});
</script>

<style scoped>
.dashboard {
  max-width: 100%;
}

.dashboard-header {
  background: #fff;
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.status-summary {
  display: flex;
  gap: 1rem;
}

.status-item {
  text-align: center;
}

.status-item .badge {
  display: block;
  font-size: 1.2rem;
  padding: 0.5rem;
  min-width: 2rem;
  margin-bottom: 0.25rem;
}

.filters {
  background: #fff;
  padding: 1rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.department-card {
  transition: transform 0.2s, box-shadow 0.2s;
}

.department-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}

.metric {
  text-align: center;
}

.metric-value {
  font-size: 1.5rem;
  font-weight: bold;
  line-height: 1;
}

.metric-label {
  font-size: 0.75rem;
  color: #6c757d;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.coverage-progress .progress {
  height: 8px;
  background-color: #e9ecef;
  border-radius: 4px;
}

.coverage-progress .progress-bar {
  transition: width 0.3s ease;
}

.quick-actions {
  display: flex;
  gap: 0.5rem;
}

.quick-actions .btn {
  flex: 1;
}

.badge-success {
  background-color: #28a745;
  color: white;
}

.badge-warning {
  background-color: #ffc107;
  color: #212529;
}

.badge-danger {
  background-color: #dc3545;
  color: white;
}

/* Time Navigation Styles */
.time-navigation .nav-tabs {
  border-bottom: 2px solid #dee2e6;
}

.time-navigation .nav-link {
  border: none;
  border-bottom: 3px solid transparent;
  background: none;
  color: #6c757d;
  font-weight: 500;
  padding: 0.75rem 1.5rem;
  cursor: pointer;
  transition: all 0.2s ease;
}

.time-navigation .nav-link:hover {
  color: #495057;
  background-color: #f8f9fa;
}

.time-navigation .nav-link.active {
  color: #007bff;
  border-bottom-color: #007bff;
  background-color: #f8f9fa;
}

.time-controls {
  background: #f8f9fa;
  padding: 1rem;
  border-radius: 0.375rem;
  border: 1px solid #dee2e6;
}

/* Porter List and Drag & Drop Styles */
.available-porters {
  border-top: 1px solid #dee2e6;
  padding-top: 1rem;
}

.porter-list {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.porter-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.5rem;
  background: #f8f9fa;
  border: 1px solid #dee2e6;
  border-radius: 0.375rem;
  cursor: grab;
  transition: all 0.2s ease;
}

.porter-item:hover {
  background: #e9ecef;
  border-color: #adb5bd;
}

.porter-item.dragging {
  opacity: 0.5;
  transform: rotate(5deg);
  cursor: grabbing;
}

.porter-item.porter-unavailable {
  background: #f8d7da;
  border-color: #f5c6cb;
  opacity: 0.7;
}

.porter-info {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.porter-name {
  font-weight: 500;
  color: #495057;
}

.porter-status {
  font-size: 0.75rem;
  padding: 0.125rem 0.375rem;
  border-radius: 0.25rem;
  text-transform: uppercase;
  font-weight: 500;
}

.porter-status.status-available {
  background: #d4edda;
  color: #155724;
}

.porter-status.status-unavailable {
  background: #f8d7da;
  color: #721c24;
}

.porter-status.status-overtime {
  background: #fff3cd;
  color: #856404;
}

.porter-capabilities {
  display: flex;
  gap: 0.25rem;
}

.capability-badge {
  font-size: 0.625rem;
  padding: 0.125rem 0.375rem;
  border-radius: 0.25rem;
  display: flex;
  align-items: center;
  gap: 0.25rem;
}

.capability-badge.badge-success {
  background: #d4edda;
  color: #155724;
}

.capability-badge.badge-warning {
  background: #fff3cd;
  color: #856404;
}

/* Drop Zone Styles */
.drop-zone {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 1rem;
  border: 2px dashed #dee2e6;
  border-radius: 0.375rem;
  background: #f8f9fa;
  color: #6c757d;
  transition: all 0.2s ease;
  margin-bottom: 1rem;
  min-height: 60px;
}

.drop-zone i {
  font-size: 1.25rem;
  margin-bottom: 0.25rem;
}

.drop-zone.drop-zone-active {
  border-color: #007bff;
  background: #e7f3ff;
  color: #007bff;
}

.drop-zone:hover {
  border-color: #adb5bd;
  background: #e9ecef;
}

.badge-secondary {
  background-color: #6c757d;
  color: white;
}

.border-success {
  border-color: #28a745 !important;
}

.border-warning {
  border-color: #ffc107 !important;
}

.border-danger {
  border-color: #dc3545 !important;
}

.border-secondary {
  border-color: #6c757d !important;
}

.bg-success {
  background-color: #28a745 !important;
}

.bg-warning {
  background-color: #ffc107 !important;
}

.bg-danger {
  background-color: #dc3545 !important;
}

.bg-secondary {
  background-color: #6c757d !important;
}

.text-primary {
  color: #007bff !important;
}

.text-success {
  color: #28a745 !important;
}

.text-danger {
  color: #dc3545 !important;
}

.spinner-border {
  width: 3rem;
  height: 3rem;
  border: 0.25em solid currentColor;
  border-right-color: transparent;
  border-radius: 50%;
  animation: spinner-border 0.75s linear infinite;
}

@keyframes spinner-border {
  to {
    transform: rotate(360deg);
  }
}

.visually-hidden {
  position: absolute !important;
  width: 1px !important;
  height: 1px !important;
  padding: 0 !important;
  margin: -1px !important;
  overflow: hidden !important;
  clip: rect(0, 0, 0, 0) !important;
  white-space: nowrap !important;
  border: 0 !important;
}
</style>
