<template>
  <div class="configure-view">
    <div class="page-header">
      <h1>System Configuration</h1>
      <p>Manage buildings, departments, services, porters, shifts, and system settings</p>
    </div>

    <!-- Tab Navigation -->
    <div class="tabs">
      <button 
        v-for="tab in tabs" 
        :key="tab.id"
        @click="activeTab = tab.id"
        :class="['tab-button', { 'tab-button-active': activeTab === tab.id }]"
      >
        {{ tab.label }}
      </button>
    </div>

    <!-- Tab Content -->
    <div class="tab-content">
      <!-- Buildings Tab -->
      <div v-if="activeTab === 'buildings'" class="tab-panel">
        <div class="panel-header">
          <h2>Buildings</h2>
          <button class="btn btn-primary" @click="showAddBuildingModal = true">
            Add Building
          </button>
        </div>
        
        <div class="data-table">
          <table class="table">
            <thead>
              <tr>
                <th>Name</th>
                <th>Address</th>
                <th>Departments</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="building in buildings" :key="building.id">
                <td>{{ building.name }}</td>
                <td>{{ building.location || building.address || 'N/A' }}</td>
                <td>{{ building.departments?.length || 0 }}</td>
                <td>
                  <button class="btn btn-sm btn-secondary" @click="editBuilding(building)">Edit</button>
                  <button class="btn btn-sm btn-danger" @click="deleteBuilding(building.id)">Delete</button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Departments Tab -->
      <div v-if="activeTab === 'departments'" class="tab-panel">
        <div class="panel-header">
          <h2>Departments</h2>
          <button class="btn btn-primary" @click="showAddDepartmentModal = true">
            Add Department
          </button>
        </div>
        
        <div class="data-table">
          <table class="table">
            <thead>
              <tr>
                <th>Name</th>
                <th>Building</th>
                <th>Services</th>
                <th>Schedule</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="department in departments" :key="department.id">
                <td>{{ department.name }}</td>
                <td>{{ department.building?.name || 'N/A' }}</td>
                <td>{{ department.services?.length || 0 }}</td>
                <td>
                  <span class="badge" :class="department.is247 ? 'badge-success' : 'badge-info'">
                    {{ department.is247 ? '24/7' : 'Scheduled' }}
                  </span>
                </td>
                <td>
                  <button class="btn btn-sm btn-secondary" @click="editDepartment(department)">Edit</button>
                  <button class="btn btn-sm btn-danger" @click="deleteDepartment(department.id)">Delete</button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Services Tab -->
      <div v-if="activeTab === 'services'" class="tab-panel">
        <div class="panel-header">
          <h2>Services</h2>
          <button class="btn btn-primary" @click="showAddServiceModal = true">
            Add Service
          </button>
        </div>
        
        <div class="data-table">
          <table class="table">
            <thead>
              <tr>
                <th>Name</th>
                <th>Department</th>
                <th>Required Porters</th>
                <th>Capabilities</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="service in services" :key="service.id">
                <td>{{ service.name }}</td>
                <td>{{ service.department?.name || 'N/A' }}</td>
                <td>{{ service.required_porters || 1 }}</td>
                <td>{{ service.capabilities?.length || 0 }}</td>
                <td>
                  <button class="btn btn-sm btn-secondary" @click="editService(service)">Edit</button>
                  <button class="btn btn-sm btn-danger" @click="deleteService(service.id)">Delete</button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Porters Tab -->
      <div v-if="activeTab === 'porters'" class="tab-panel">
        <div class="panel-header">
          <h2>Porters</h2>
          <button class="btn btn-primary" @click="showAddPorterModal = true">
            Add Porter
          </button>
        </div>
        
        <div class="data-table">
          <table class="table">
            <thead>
              <tr>
                <th>Name</th>
                <th>Employee ID</th>
                <th>Contract Type</th>
                <th>Shift Pattern</th>
                <th>Capabilities</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="porter in porters" :key="porter.id">
                <td>{{ porter.name }}</td>
                <td>{{ porter.employee_id || porter.employeeId }}</td>
                <td>
                  <span class="badge" :class="getContractTypeClass(porter.contract_type || porter.contractType)">
                    {{ porter.contract_type || porter.contractType }}
                  </span>
                </td>
                <td>{{ porter.shift_pattern?.name || 'None' }}</td>
                <td>{{ porter.capabilities?.length || 0 }}</td>
                <td>
                  <button class="btn btn-sm btn-secondary" @click="editPorter(porter)">Edit</button>
                  <button class="btn btn-sm btn-danger" @click="deletePorter(porter.id)">Delete</button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Shifts Tab -->
      <div v-if="activeTab === 'shifts'" class="tab-panel">
        <div class="panel-header">
          <h2>Shift Patterns</h2>
          <button class="btn btn-primary" @click="showAddShiftPatternModal = true">
            Add Shift Pattern
          </button>
        </div>
        
        <div class="data-table">
          <table class="table">
            <thead>
              <tr>
                <th>Name</th>
                <th>Pattern</th>
                <th>Description</th>
                <th>Created</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="shiftPattern in shiftPatterns" :key="shiftPattern.id">
                <td>{{ shiftPattern.name }}</td>
                <td>{{ formatShiftPattern(shiftPattern.patternJson) }}</td>
                <td>{{ shiftPattern.description || 'N/A' }}</td>
                <td>{{ formatDate(shiftPattern.createdAt) }}</td>
                <td>
                  <button class="btn btn-sm btn-secondary" @click="editShiftPattern(shiftPattern)">Edit</button>
                  <button class="btn btn-sm btn-danger" @click="deleteShiftPattern(shiftPattern.id)">Delete</button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Settings Tab -->
      <div v-if="activeTab === 'settings'" class="tab-panel">
        <div class="panel-header">
          <h2>System Settings</h2>
          <button class="btn btn-primary" @click="saveSettings">
            Save Settings
          </button>
        </div>
        
        <div class="settings-grid">
          <div class="setting-group">
            <h3>Shift Times</h3>
            <div class="form-group">
              <label>Day Shift Start</label>
              <input 
                type="time" 
                v-model="settings.day_shift_start" 
                class="form-control"
              />
            </div>
            <div class="form-group">
              <label>Day Shift End</label>
              <input 
                type="time" 
                v-model="settings.day_shift_end" 
                class="form-control"
              />
            </div>
            <div class="form-group">
              <label>Night Shift Start</label>
              <input 
                type="time" 
                v-model="settings.night_shift_start" 
                class="form-control"
              />
            </div>
            <div class="form-group">
              <label>Night Shift End</label>
              <input 
                type="time" 
                v-model="settings.night_shift_end" 
                class="form-control"
              />
            </div>
          </div>

          <div class="setting-group">
            <h3>Capability Management</h3>
            <div class="form-group">
              <label>
                <input 
                  type="checkbox" 
                  v-model="settings.enforce_capability_expiry"
                />
                Enforce Capability Expiry
              </label>
            </div>
            <div class="form-group">
              <label>Relief Hour Warning Threshold</label>
              <input 
                type="number" 
                step="0.1" 
                min="0" 
                max="1" 
                v-model="settings.relief_hour_warning_threshold" 
                class="form-control"
              />
            </div>
          </div>
        </div>
      </div>

      <!-- Capabilities Tab -->
      <div v-if="activeTab === 'capabilities'" class="tab-panel">
        <div class="panel-header">
          <h2>Capabilities Management</h2>
          <button class="btn btn-primary" @click="showAddCapabilityModal = true">
            Add Capability
          </button>
        </div>

        <div class="table-container">
          <table class="data-table">
            <thead>
              <tr>
                <th>Name</th>
                <th>Description</th>
                <th>Porters</th>
                <th>Departments</th>
                <th>Services</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="capability in capabilities" :key="capability.id">
                <td>{{ capability.name }}</td>
                <td>{{ capability.description || 'N/A' }}</td>
                <td>{{ capability.porterCapabilities?.length || 0 }}</td>
                <td>{{ capability.departmentCapabilities?.length || 0 }}</td>
                <td>{{ capability.serviceCapabilities?.length || 0 }}</td>
                <td>
                  <button
                    class="btn btn-sm btn-secondary"
                    @click="editCapability(capability)"
                  >
                    Edit
                  </button>
                  <button
                    class="btn btn-sm btn-danger"
                    @click="deleteCapability(capability.id)"
                  >
                    Delete
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Allocations Tab -->
      <div v-if="activeTab === 'allocations'" class="tab-panel">
        <div class="panel-header">
          <h2>Porter Allocations</h2>
          <button class="btn btn-primary" @click="showAddAllocationModal = true">
            Add Allocation
          </button>
        </div>

        <div class="table-container">
          <table class="data-table">
            <thead>
              <tr>
                <th>Porter</th>
                <th>Department</th>
                <th>Service</th>
                <th>Type</th>
                <th>Start Date</th>
                <th>End Date</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="allocation in allocations" :key="allocation.id">
                <td>{{ allocation.porter?.name }}</td>
                <td>{{ allocation.department?.name }}</td>
                <td>{{ allocation.service?.name || 'N/A' }}</td>
                <td>
                  <span :class="['badge', 'badge-' + allocation.type.toLowerCase()]">
                    {{ allocation.type }}
                  </span>
                </td>
                <td>{{ formatDateTime(allocation.startDatetime) }}</td>
                <td>{{ allocation.endDatetime ? formatDateTime(allocation.endDatetime) : 'Ongoing' }}</td>
                <td>
                  <span :class="['badge', getAllocationStatusClass(allocation)]">
                    {{ getAllocationStatus(allocation) }}
                  </span>
                </td>
                <td>
                  <button
                    class="btn btn-sm btn-secondary"
                    @click="editAllocation(allocation)"
                  >
                    Edit
                  </button>
                  <button
                    class="btn btn-sm btn-danger"
                    @click="deleteAllocation(allocation.id)"
                  >
                    Delete
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Availability Tab -->
      <div v-if="activeTab === 'availability'" class="tab-panel">
        <div class="panel-header">
          <h2>Porter Availability</h2>
          <button class="btn btn-primary" @click="showAddAvailabilityModal = true">
            Add Availability Record
          </button>
        </div>

        <div class="table-container">
          <table class="data-table">
            <thead>
              <tr>
                <th>Porter</th>
                <th>Status</th>
                <th>Start Date</th>
                <th>End Date</th>
                <th>Reason</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="availability in availabilityRecords" :key="availability.id">
                <td>{{ availability.porter?.name }}</td>
                <td>
                  <span :class="['badge', 'badge-' + availability.status.toLowerCase()]">
                    {{ availability.status }}
                  </span>
                </td>
                <td>{{ formatDateTime(availability.startDatetime) }}</td>
                <td>{{ formatDateTime(availability.endDatetime) }}</td>
                <td>{{ availability.reason || 'N/A' }}</td>
                <td>
                  <button
                    class="btn btn-sm btn-secondary"
                    @click="editAvailability(availability)"
                  >
                    Edit
                  </button>
                  <button
                    class="btn btn-sm btn-danger"
                    @click="deleteAvailability(availability.id)"
                  >
                    Delete
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- Add Building Modal -->
    <Modal
      :is-open="showAddBuildingModal"
      title="Add Building"
      :saving="savingBuilding"
      @close="showAddBuildingModal = false"
      @save="saveBuilding"
    >
      <BuildingForm
        ref="buildingFormRef"
        :building="editingBuilding"
        @submit="saveBuilding"
      />
    </Modal>

    <!-- Add Department Modal -->
    <Modal
      :is-open="showAddDepartmentModal"
      :title="editingDepartment ? 'Edit Department' : 'Add Department'"
      :saving="savingDepartment"
      @close="showAddDepartmentModal = false"
      @save="saveDepartment"
    >
      <DepartmentForm
        ref="departmentFormRef"
        :department="editingDepartment"
        :buildings="buildings"
        @submit="saveDepartment"
      />
    </Modal>

    <!-- Add Service Modal -->
    <Modal
      :is-open="showAddServiceModal"
      :title="editingService ? 'Edit Service' : 'Add Service'"
      :saving="savingService"
      @close="showAddServiceModal = false"
      @save="saveService"
    >
      <ServiceForm
        ref="serviceFormRef"
        :service="editingService"
        :departments="departments"
        @submit="saveService"
      />
    </Modal>

    <!-- Add Porter Modal -->
    <Modal
      :is-open="showAddPorterModal"
      :title="editingPorter ? 'Edit Porter' : 'Add Porter'"
      :saving="savingPorter"
      @close="showAddPorterModal = false"
      @save="savePorter"
    >
      <PorterForm
        ref="porterFormRef"
        :porter="editingPorter"
        :departments="departments"
        :shifts="shifts"
        @submit="savePorter"
      />
    </Modal>

    <!-- Add Shift Pattern Modal -->
    <Modal
      :is-open="showAddShiftPatternModal"
      :title="editingShiftPattern ? 'Edit Shift Pattern' : 'Add Shift Pattern'"
      :saving="savingShiftPattern"
      @close="showAddShiftPatternModal = false"
      @save="saveShiftPattern"
    >
      <ShiftPatternForm
        ref="shiftPatternFormRef"
        :shift-pattern="editingShiftPattern"
      />
    </Modal>

    <!-- Add Capability Modal -->
    <Modal
      :is-open="showAddCapabilityModal"
      :title="editingCapability ? 'Edit Capability' : 'Add Capability'"
      :saving="savingCapability"
      @close="showAddCapabilityModal = false"
      @save="saveCapability"
    >
      <CapabilityForm
        ref="capabilityFormRef"
        :capability="editingCapability"
        @submit="saveCapability"
        @cancel="showAddCapabilityModal = false"
      />
    </Modal>

    <!-- Add Allocation Modal -->
    <Modal
      :is-open="showAddAllocationModal"
      :title="editingAllocation ? 'Edit Allocation' : 'Add Allocation'"
      :saving="savingAllocation"
      @close="showAddAllocationModal = false"
      @save="saveAllocation"
    >
      <AllocationForm
        ref="allocationFormRef"
        :allocation="editingAllocation"
        @submit="saveAllocation"
        @cancel="showAddAllocationModal = false"
      />
    </Modal>

    <!-- Add Availability Modal -->
    <Modal
      :is-open="showAddAvailabilityModal"
      :title="editingAvailability ? 'Edit Availability' : 'Add Availability'"
      :saving="savingAvailability"
      @close="showAddAvailabilityModal = false"
      @save="saveAvailability"
    >
      <AvailabilityForm
        ref="availabilityFormRef"
        :availability="editingAvailability"
        @submit="saveAvailability"
        @cancel="showAddAvailabilityModal = false"
      />
    </Modal>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import Modal from './Modal.vue'
import BuildingForm from './BuildingForm.vue'
import DepartmentForm from './DepartmentForm.vue'
import ServiceForm from './ServiceForm.vue'
import PorterForm from './PorterForm.vue'
import ShiftPatternForm from './ShiftPatternForm.vue'
import CapabilityForm from './CapabilityForm.vue'
import AllocationForm from './AllocationForm.vue'
import AvailabilityForm from './AvailabilityForm.vue'

// Tab management
const activeTab = ref('buildings')
const tabs = [
  { id: 'buildings', label: 'Buildings' },
  { id: 'departments', label: 'Departments' },
  { id: 'services', label: 'Services' },
  { id: 'porters', label: 'Porters' },
  { id: 'shifts', label: 'Shift Patterns' },
  { id: 'capabilities', label: 'Capabilities' },
  { id: 'allocations', label: 'Allocations' },
  { id: 'availability', label: 'Availability' },
  { id: 'settings', label: 'Settings' }
]

// Data
const buildings = ref([])
const departments = ref([])
const services = ref([])
const porters = ref([])
const shifts = ref([])
const shiftPatterns = ref([])
const capabilities = ref([])
const allocations = ref([])
const availabilityRecords = ref([])
const settings = ref({
  day_shift_start: '08:00',
  day_shift_end: '20:00',
  night_shift_start: '20:00',
  night_shift_end: '08:00',
  enforce_capability_expiry: false,
  relief_hour_warning_threshold: 0.8
})

// Modal states
const showAddBuildingModal = ref(false)
const showAddDepartmentModal = ref(false)
const showAddServiceModal = ref(false)
const showAddPorterModal = ref(false)
const showAddShiftModal = ref(false)
const showAddShiftPatternModal = ref(false)
const showAddCapabilityModal = ref(false)
const showAddAllocationModal = ref(false)
const showAddAvailabilityModal = ref(false)

// Form states
const editingBuilding = ref(null)
const savingBuilding = ref(false)
const buildingFormRef = ref(null)

const editingDepartment = ref(null)
const savingDepartment = ref(false)
const departmentFormRef = ref(null)

const editingService = ref(null)
const savingService = ref(false)
const serviceFormRef = ref(null)

const editingPorter = ref(null)
const savingPorter = ref(false)
const porterFormRef = ref(null)

const editingShiftPattern = ref(null)
const savingShiftPattern = ref(false)
const shiftPatternFormRef = ref(null)

const editingCapability = ref(null)
const savingCapability = ref(false)
const capabilityFormRef = ref(null)

const editingAllocation = ref(null)
const savingAllocation = ref(false)
const allocationFormRef = ref(null)

const editingAvailability = ref(null)
const savingAvailability = ref(false)
const availabilityFormRef = ref(null)

// Methods
const fetchData = async () => {
  try {
    console.log('Fetching configuration data...')

    // Fetch all data in parallel
    const [buildingsRes, departmentsRes, servicesRes, portersRes, shiftsRes, shiftPatternsRes, capabilitiesRes, allocationsRes, availabilityRes, settingsRes] = await Promise.all([
      fetch('http://localhost:3001/api/buildings'),
      fetch('http://localhost:3001/api/departments'),
      fetch('http://localhost:3001/api/services'),
      fetch('http://localhost:3001/api/porters'),
      fetch('http://localhost:3001/api/shifts'),
      fetch('http://localhost:3001/api/shift-patterns'),
      fetch('http://localhost:3001/api/capabilities'),
      fetch('http://localhost:3001/api/allocations'),
      fetch('http://localhost:3001/api/availability'),
      fetch('http://localhost:3001/api/settings')
    ])

    // Parse responses
    const buildingsData = await buildingsRes.json()
    const departmentsData = await departmentsRes.json()
    const servicesData = await servicesRes.json()
    const portersData = await portersRes.json()
    const shiftsData = await shiftsRes.json()
    const shiftPatternsData = await shiftPatternsRes.json()
    const capabilitiesData = await capabilitiesRes.json()
    const allocationsData = await allocationsRes.json()
    const availabilityData = await availabilityRes.json()
    const settingsData = await settingsRes.json()

    // Update reactive data
    if (buildingsData.success) {
      buildings.value = buildingsData.data
    }

    if (departmentsData.success) {
      departments.value = departmentsData.data
    }

    if (servicesData.success) {
      services.value = servicesData.data
    }

    if (portersData.success) {
      porters.value = portersData.data
    }

    if (shiftsData.success) {
      shifts.value = shiftsData.data
    }

    if (shiftPatternsData.success) {
      shiftPatterns.value = shiftPatternsData.data
    }

    if (capabilitiesData.success) {
      capabilities.value = capabilitiesData.data
    }

    if (allocationsData.success) {
      allocations.value = allocationsData.data
    }

    if (availabilityData.success) {
      availabilityRecords.value = availabilityData.data
    }

    if (settingsData.success) {
      // Merge with default settings
      settings.value = { ...settings.value, ...settingsData.data }
    }

    // Mock shift patterns for now (will implement later)
    shiftPatterns.value = [
      {
        id: 1,
        name: '4 on 4 off Pattern',
        pattern: [
          { type: 'day', label: 'Day Shift', duration_days: 4 },
          { type: 'off', label: 'Rest', duration_days: 4 }
        ],
        ground_zero_date: '2024-01-01',
        offset_days: 0
      }
    ]

    console.log('Data fetched successfully:', {
      buildings: buildings.value.length,
      departments: departments.value.length,
      services: services.value.length,
      porters: porters.value.length
    })
  } catch (error) {
    console.error('Error fetching data:', error)
  }
}

const getContractTypeClass = (type: string) => {
  switch (type) {
    case 'SHIFT': return 'badge-primary'
    case 'FIXED': return 'badge-success'
    case 'RELIEF': return 'badge-warning'
    default: return 'badge-secondary'
  }
}



// Building CRUD operations
const editBuilding = (building: any) => {
  editingBuilding.value = building
  showAddBuildingModal.value = true
}

const deleteBuilding = async (id: string) => {
  if (!confirm('Are you sure you want to delete this building?')) {
    return
  }

  try {
    const response = await fetch(`http://localhost:3001/api/buildings/${id}`, {
      method: 'DELETE'
    })

    const result = await response.json()

    if (result.success) {
      // Remove from local data
      buildings.value = buildings.value.filter(b => b.id !== id)
      console.log('Building deleted successfully')
    } else {
      alert('Failed to delete building: ' + result.error)
    }
  } catch (error) {
    console.error('Error deleting building:', error)
    alert('Failed to delete building')
  }
}

const saveBuilding = async (buildingData?: any) => {
  try {
    savingBuilding.value = true

    // Get data from form if not provided
    const data = buildingData || buildingFormRef.value?.form

    if (!data || !data.name?.trim()) {
      alert('Please enter a building name')
      return
    }

    const isEditing = !!editingBuilding.value?.id
    const url = isEditing
      ? `http://localhost:3001/api/buildings/${editingBuilding.value.id}`
      : 'http://localhost:3001/api/buildings'

    const method = isEditing ? 'PUT' : 'POST'

    const response = await fetch(url, {
      method,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        name: data.name,
        location: data.location,
        description: data.description
      })
    })

    const result = await response.json()

    if (result.success) {
      if (isEditing) {
        // Update existing building in local data
        const index = buildings.value.findIndex(b => b.id === editingBuilding.value.id)
        if (index !== -1) {
          buildings.value[index] = result.data
        }
      } else {
        // Add new building to local data
        buildings.value.push(result.data)
      }

      // Close modal and reset form
      showAddBuildingModal.value = false
      editingBuilding.value = null
      console.log('Building saved successfully')
    } else {
      alert('Failed to save building: ' + result.error)
    }
  } catch (error) {
    console.error('Error saving building:', error)
    alert('Failed to save building')
  } finally {
    savingBuilding.value = false
  }
}

const editDepartment = (department: any) => {
  editingDepartment.value = department
  showAddDepartmentModal.value = true
}

const deleteDepartment = async (id: string) => {
  if (!confirm('Are you sure you want to delete this department?')) {
    return
  }

  try {
    const response = await fetch(`http://localhost:3001/api/departments/${id}`, {
      method: 'DELETE'
    })

    const result = await response.json()

    if (result.success) {
      // Remove from local data
      departments.value = departments.value.filter(d => d.id !== id)
      console.log('Department deleted successfully')
    } else {
      alert('Failed to delete department: ' + result.error)
    }
  } catch (error) {
    console.error('Error deleting department:', error)
    alert('Failed to delete department')
  }
}

const saveDepartment = async (departmentData?: any) => {
  try {
    savingDepartment.value = true

    // Get data from form if not provided
    const data = departmentData || departmentFormRef.value?.form

    if (!data || !data.name?.trim() || !data.building_id) {
      alert('Please enter a department name and select a building')
      return
    }

    const isEditing = !!editingDepartment.value?.id
    const url = isEditing
      ? `http://localhost:3001/api/departments/${editingDepartment.value.id}`
      : 'http://localhost:3001/api/departments'

    const method = isEditing ? 'PUT' : 'POST'

    const response = await fetch(url, {
      method,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        name: data.name,
        building_id: data.building_id,
        description: data.description,
        is_24_7: data.is_24_7
      })
    })

    const result = await response.json()

    if (result.success) {
      if (isEditing) {
        // Update existing department in local data
        const index = departments.value.findIndex(d => d.id === editingDepartment.value.id)
        if (index !== -1) {
          departments.value[index] = result.data
        }
      } else {
        // Add new department to local data
        departments.value.push(result.data)
      }

      // Close modal and reset form
      showAddDepartmentModal.value = false
      editingDepartment.value = null
      console.log('Department saved successfully')
    } else {
      alert('Failed to save department: ' + result.error)
    }
  } catch (error) {
    console.error('Error saving department:', error)
    alert('Failed to save department')
  } finally {
    savingDepartment.value = false
  }
}

const editService = (service: any) => {
  editingService.value = service
  showAddServiceModal.value = true
}

const deleteService = async (id: string) => {
  if (!confirm('Are you sure you want to delete this service?')) {
    return
  }

  try {
    const response = await fetch(`http://localhost:3001/api/services/${id}`, {
      method: 'DELETE'
    })

    const result = await response.json()

    if (result.success) {
      // Remove from local data
      services.value = services.value.filter(s => s.id !== id)
      console.log('Service deleted successfully')
    } else {
      alert('Failed to delete service: ' + result.error)
    }
  } catch (error) {
    console.error('Error deleting service:', error)
    alert('Failed to delete service')
  }
}

const saveService = async (serviceData?: any) => {
  try {
    savingService.value = true

    // Get data from form if not provided
    const data = serviceData || serviceFormRef.value?.form

    if (!data || !data.name?.trim() || !data.department_id) {
      alert('Please enter a service name and select a department')
      return
    }

    const isEditing = !!editingService.value?.id
    const url = isEditing
      ? `http://localhost:3001/api/services/${editingService.value.id}`
      : 'http://localhost:3001/api/services'

    const method = isEditing ? 'PUT' : 'POST'

    const response = await fetch(url, {
      method,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        name: data.name,
        department_id: data.department_id,
        description: data.description,
        uses_custom_schedule: data.uses_custom_schedule
      })
    })

    const result = await response.json()

    if (result.success) {
      if (isEditing) {
        // Update existing service in local data
        const index = services.value.findIndex(s => s.id === editingService.value.id)
        if (index !== -1) {
          services.value[index] = result.data
        }
      } else {
        // Add new service to local data
        services.value.push(result.data)
      }

      // Close modal and reset form
      showAddServiceModal.value = false
      editingService.value = null
      console.log('Service saved successfully')
    } else {
      alert('Failed to save service: ' + result.error)
    }
  } catch (error) {
    console.error('Error saving service:', error)
    alert('Failed to save service')
  } finally {
    savingService.value = false
  }
}

const editPorter = (porter: any) => {
  editingPorter.value = porter
  showAddPorterModal.value = true
}

const deletePorter = async (id: string) => {
  if (!confirm('Are you sure you want to delete this porter?')) {
    return
  }

  try {
    const response = await fetch(`http://localhost:3001/api/porters/${id}`, {
      method: 'DELETE'
    })

    const result = await response.json()

    if (result.success) {
      // Remove from local data
      porters.value = porters.value.filter(p => p.id !== id)
      console.log('Porter deleted successfully')
    } else {
      alert('Failed to delete porter: ' + result.error)
    }
  } catch (error) {
    console.error('Error deleting porter:', error)
    alert('Failed to delete porter')
  }
}

const savePorter = async (porterData?: any) => {
  try {
    savingPorter.value = true

    // Get data from form if not provided
    const data = porterData || porterFormRef.value?.form

    if (!data || !data.name?.trim() || !data.contract_type) {
      alert('Please enter a porter name and select a contract type')
      return
    }

    const isEditing = !!editingPorter.value?.id
    const url = isEditing
      ? `http://localhost:3001/api/porters/${editingPorter.value.id}`
      : 'http://localhost:3001/api/porters'

    const method = isEditing ? 'PUT' : 'POST'

    const response = await fetch(url, {
      method,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        name: data.name,
        contract_type: data.contract_type,
        porter_type: data.porter_type,
        regular_department_id: data.regular_department_id || null,
        shift_id: data.shift_id || null,
        weekly_min_hours: data.weekly_min_hours || null,
        contracted_hours: data.contracted_hours || null,
        counts_towards_staffing: data.counts_towards_staffing
      })
    })

    const result = await response.json()

    if (result.success) {
      if (isEditing) {
        // Update existing porter in local data
        const index = porters.value.findIndex(p => p.id === editingPorter.value.id)
        if (index !== -1) {
          porters.value[index] = result.data
        }
      } else {
        // Add new porter to local data
        porters.value.push(result.data)
      }

      // Close modal and reset form
      showAddPorterModal.value = false
      editingPorter.value = null
      console.log('Porter saved successfully')
    } else {
      alert('Failed to save porter: ' + result.error)
    }
  } catch (error) {
    console.error('Error saving porter:', error)
    alert('Failed to save porter')
  } finally {
    savingPorter.value = false
  }
}

// Shift Pattern methods
const editShiftPattern = (shiftPattern: any) => {
  editingShiftPattern.value = shiftPattern
  showAddShiftPatternModal.value = true
}

const deleteShiftPattern = async (id: string) => {
  if (!confirm('Are you sure you want to delete this shift pattern?')) {
    return
  }

  try {
    const response = await fetch(`http://localhost:3001/api/shift-patterns/${id}`, {
      method: 'DELETE'
    })

    const result = await response.json()

    if (result.success) {
      // Remove from local data
      shiftPatterns.value = shiftPatterns.value.filter(sp => sp.id !== id)
      console.log('Shift pattern deleted successfully')
    } else {
      alert('Failed to delete shift pattern: ' + result.error)
    }
  } catch (error) {
    console.error('Error deleting shift pattern:', error)
    alert('Failed to delete shift pattern')
  }
}

const saveShiftPattern = async (shiftPatternData?: any) => {
  try {
    savingShiftPattern.value = true

    // Get data from form if not provided
    const data = shiftPatternData || shiftPatternFormRef.value?.form

    if (!data || !data.name?.trim() || !data.pattern?.length) {
      alert('Please enter a name and at least one pattern segment')
      return
    }

    const isEditing = !!editingShiftPattern.value?.id
    const url = isEditing
      ? `http://localhost:3001/api/shift-patterns/${editingShiftPattern.value.id}`
      : 'http://localhost:3001/api/shift-patterns'

    const method = isEditing ? 'PUT' : 'POST'

    const response = await fetch(url, {
      method,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        name: data.name,
        description: data.description || null,
        pattern: data.pattern
      })
    })

    const result = await response.json()

    if (result.success) {
      if (isEditing) {
        // Update existing shift pattern in local data
        const index = shiftPatterns.value.findIndex(sp => sp.id === editingShiftPattern.value.id)
        if (index !== -1) {
          shiftPatterns.value[index] = result.data
        }
      } else {
        // Add new shift pattern to local data
        shiftPatterns.value.push(result.data)
      }

      // Close modal and reset form
      showAddShiftPatternModal.value = false
      editingShiftPattern.value = null
      console.log('Shift pattern saved successfully')
    } else {
      alert('Failed to save shift pattern: ' + result.error)
    }
  } catch (error) {
    console.error('Error saving shift pattern:', error)
    alert('Failed to save shift pattern')
  } finally {
    savingShiftPattern.value = false
  }
}

// Helper functions
const formatShiftPattern = (patternJson: string) => {
  if (!patternJson) return 'N/A'
  try {
    const pattern = JSON.parse(patternJson)
    if (!Array.isArray(pattern)) return 'N/A'
    return pattern.map(segment => `${segment.label} (${segment.duration_days}d)`).join(', ')
  } catch (e) {
    return 'Invalid Pattern'
  }
}

const formatDate = (dateString: string) => {
  if (!dateString) return 'N/A'
  return new Date(dateString).toLocaleDateString()
}

const editShift = (shift: any) => {
  console.log('Edit shift:', shift)
}

const deleteShift = (id: number) => {
  console.log('Delete shift:', id)
}

const saveSettings = async () => {
  try {
    const response = await fetch('http://localhost:3001/api/settings', {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(settings.value)
    })

    const result = await response.json()
    if (result.success) {
      alert('Settings saved successfully!')
    } else {
      alert('Failed to save settings: ' + result.error)
    }
  } catch (error) {
    console.error('Error saving settings:', error)
    alert('Failed to save settings')
  }
}

// Helper functions for new entities
const formatDateTime = (dateString: string) => {
  if (!dateString) return 'N/A'
  return new Date(dateString).toLocaleString()
}

const getAllocationStatus = (allocation: any) => {
  const now = new Date()
  const start = new Date(allocation.startDatetime)
  const end = allocation.endDatetime ? new Date(allocation.endDatetime) : null

  if (start > now) return 'Scheduled'
  if (!end || end > now) return 'Active'
  return 'Ended'
}

const getAllocationStatusClass = (allocation: any) => {
  const status = getAllocationStatus(allocation)
  switch (status) {
    case 'Active': return 'badge-success'
    case 'Scheduled': return 'badge-warning'
    case 'Ended': return 'badge-secondary'
    default: return 'badge-secondary'
  }
}

// Capability management
const editCapability = (capability: any) => {
  editingCapability.value = capability
  showAddCapabilityModal.value = true
}

const deleteCapability = async (id: string) => {
  if (!confirm('Are you sure you want to delete this capability?')) return

  try {
    const response = await fetch(`http://localhost:3001/api/capabilities/${id}`, {
      method: 'DELETE'
    })

    if (response.ok) {
      await fetchData()
    } else {
      alert('Failed to delete capability')
    }
  } catch (error) {
    console.error('Error deleting capability:', error)
    alert('Failed to delete capability')
  }
}

const saveCapability = async (capabilityData: any) => {
  savingCapability.value = true
  try {
    await fetchData()
    showAddCapabilityModal.value = false
    editingCapability.value = null
  } catch (error) {
    console.error('Error saving capability:', error)
  } finally {
    savingCapability.value = false
  }
}

// Allocation management
const editAllocation = (allocation: any) => {
  editingAllocation.value = allocation
  showAddAllocationModal.value = true
}

const deleteAllocation = async (id: string) => {
  if (!confirm('Are you sure you want to delete this allocation?')) return

  try {
    const response = await fetch(`http://localhost:3001/api/allocations/${id}`, {
      method: 'DELETE'
    })

    if (response.ok) {
      await fetchData()
    } else {
      alert('Failed to delete allocation')
    }
  } catch (error) {
    console.error('Error deleting allocation:', error)
    alert('Failed to delete allocation')
  }
}

const saveAllocation = async (allocationData: any) => {
  savingAllocation.value = true
  try {
    await fetchData()
    showAddAllocationModal.value = false
    editingAllocation.value = null
  } catch (error) {
    console.error('Error saving allocation:', error)
  } finally {
    savingAllocation.value = false
  }
}

// Availability management
const editAvailability = (availability: any) => {
  editingAvailability.value = availability
  showAddAvailabilityModal.value = true
}

const deleteAvailability = async (id: string) => {
  if (!confirm('Are you sure you want to delete this availability record?')) return

  try {
    const response = await fetch(`http://localhost:3001/api/availability/${id}`, {
      method: 'DELETE'
    })

    if (response.ok) {
      await fetchData()
    } else {
      alert('Failed to delete availability record')
    }
  } catch (error) {
    console.error('Error deleting availability:', error)
    alert('Failed to delete availability record')
  }
}

const saveAvailability = async (availabilityData: any) => {
  savingAvailability.value = true
  try {
    await fetchData()
    showAddAvailabilityModal.value = false
    editingAvailability.value = null
  } catch (error) {
    console.error('Error saving availability:', error)
  } finally {
    savingAvailability.value = false
  }
}

onMounted(() => {
  fetchData()
})
</script>

<style scoped>
.configure-view {
  padding: 2rem;
  max-width: 1200px;
  margin: 0 auto;
}

.page-header {
  margin-bottom: 2rem;
}

.page-header h1 {
  margin: 0 0 0.5rem 0;
  color: #333;
}

.page-header p {
  margin: 0;
  color: #666;
}

.tabs {
  display: flex;
  border-bottom: 2px solid #e0e0e0;
  margin-bottom: 2rem;
  gap: 0.5rem;
}

.tab-button {
  padding: 0.75rem 1.5rem;
  border: none;
  background: none;
  cursor: pointer;
  border-bottom: 3px solid transparent;
  font-weight: 500;
  color: #666;
  transition: all 0.2s ease;
}

.tab-button:hover {
  color: #333;
  background-color: #f5f5f5;
}

.tab-button-active {
  color: #2196f3;
  border-bottom-color: #2196f3;
  background-color: #f8f9fa;
}

.tab-content {
  min-height: 400px;
}

.tab-panel {
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

.panel-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
}

.panel-header h2 {
  margin: 0;
  color: #333;
}

.data-table, .table-container {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  overflow: hidden;
}

.table {
  width: 100%;
  border-collapse: collapse;
}

.table th,
.table td {
  padding: 1rem;
  text-align: left;
  border-bottom: 1px solid #e0e0e0;
}

.table th {
  background-color: #f8f9fa;
  font-weight: 600;
  color: #333;
}

.table tbody tr:hover {
  background-color: #f8f9fa;
}

.btn {
  padding: 0.5rem 1rem;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-weight: 500;
  text-decoration: none;
  display: inline-block;
  transition: all 0.2s ease;
  margin-right: 0.5rem;
}

.btn-primary {
  background-color: #2196f3;
  color: white;
}

.btn-primary:hover {
  background-color: #1976d2;
}

.btn-secondary {
  background-color: #6c757d;
  color: white;
}

.btn-secondary:hover {
  background-color: #545b62;
}

.btn-danger {
  background-color: #dc3545;
  color: white;
}

.btn-danger:hover {
  background-color: #c82333;
}

.btn-sm {
  padding: 0.25rem 0.5rem;
  font-size: 0.875rem;
}

.btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.badge {
  display: inline-block;
  padding: 0.25rem 0.5rem;
  font-size: 0.75rem;
  font-weight: 500;
  border-radius: 12px;
  text-transform: uppercase;
}

.badge-regular {
  background-color: #e3f2fd;
  color: #1976d2;
}

.badge-temporary {
  background-color: #fff3e0;
  color: #f57c00;
}

.badge-relief {
  background-color: #f3e5f5;
  color: #7b1fa2;
}

.badge-available {
  background-color: #e8f5e8;
  color: #2e7d32;
}

.badge-unavailable {
  background-color: #ffebee;
  color: #c62828;
}

.badge-overtime {
  background-color: #fff8e1;
  color: #f57f17;
}

.badge-success {
  background-color: #e8f5e8;
  color: #2e7d32;
}

.badge-warning {
  background-color: #fff8e1;
  color: #f57f17;
}

.badge-secondary {
  background-color: #f5f5f5;
  color: #616161;
}

.badge-primary {
  background-color: #e3f2fd;
  color: #1976d2;
}

.badge-info {
  background-color: #e1f5fe;
  color: #0277bd;
}

.settings-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
}

.setting-group {
  background: white;
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.setting-group h3 {
  margin: 0 0 1rem 0;
  color: #333;
}

.form-group {
  margin-bottom: 1rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
  color: #333;
}

.form-control {
  width: 100%;
  padding: 0.5rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 1rem;
}

.form-control:focus {
  outline: none;
  border-color: #2196f3;
  box-shadow: 0 0 0 2px rgba(33, 150, 243, 0.2);
}
</style>
