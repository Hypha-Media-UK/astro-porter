<template>
  <div class="configure-view">
    <!-- Tab Navigation -->
    <div class="border-b border-gray-200 dark:border-gray-700 mb-6">
      <nav class="-mb-px flex space-x-8" aria-label="Tabs">
        <button
          v-for="tab in tabs"
          :key="tab.id"
          @click="activeTab = tab.id"
          :class="[
            'whitespace-nowrap py-2 px-1 border-b-2 font-medium text-sm',
            activeTab === tab.id
              ? 'border-primary-500 text-primary-600 dark:text-primary-400'
              : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 dark:text-gray-400 dark:hover:text-gray-300'
          ]"
        >
          <i :class="tab.icon" class="mr-2"></i>
          {{ tab.label }}
          <span v-if="tab.count !== undefined" class="ml-2 badge badge-secondary">
            {{ tab.count }}
          </span>
        </button>
      </nav>
    </div>

    <!-- Tab Content -->
    <div class="tab-content">
      <!-- Buildings Tab -->
      <div v-if="activeTab === 'buildings'" class="space-y-6">
        <!-- Header -->
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-xl font-semibold text-gray-900 dark:text-white">Buildings</h2>
            <p class="text-sm text-gray-500 dark:text-gray-400">Manage hospital buildings and facilities</p>
          </div>
          <button @click="openBuildingModal()" class="btn-primary">
            <i class="fas fa-plus mr-2"></i>
            Add Building
          </button>
        </div>

        <!-- Buildings Table -->
        <div class="card">
          <div class="card-body p-0">
            <div class="overflow-x-auto">
              <table class="table">
                <thead class="bg-gray-50 dark:bg-gray-700">
                  <tr>
                    <th class="table-header-cell">Name</th>
                    <th class="table-header-cell">Address</th>
                    <th class="table-header-cell">Contact</th>
                    <th class="table-header-cell">Hours</th>
                    <th class="table-header-cell">Status</th>
                    <th class="table-header-cell">Actions</th>
                  </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200 dark:bg-gray-800 dark:divide-gray-700">
                  <tr v-for="building in buildings" :key="building.id" class="table-row">
                    <td class="table-cell">
                      <div class="flex items-center">
                        <div class="w-8 h-8 bg-primary-100 rounded-lg flex items-center justify-center mr-3 dark:bg-primary-900">
                          <i class="fas fa-building text-primary-600 text-sm dark:text-primary-300"></i>
                        </div>
                        <div>
                          <div class="text-sm font-medium text-gray-900 dark:text-white">{{ building.name }}</div>
                          <div class="text-sm text-gray-500 dark:text-gray-400">{{ building.departments?.length || 0 }} departments</div>
                        </div>
                      </div>
                    </td>
                    <td class="table-cell">
                      <div class="text-sm text-gray-900 dark:text-white">{{ building.address || 'No address' }}</div>
                    </td>
                    <td class="table-cell">
                      <div v-if="building.contact_name" class="text-sm text-gray-900 dark:text-white">
                        {{ building.contact_name }}
                        <div v-if="building.contact_phone" class="text-sm text-gray-500 dark:text-gray-400">
                          {{ building.contact_phone }}
                        </div>
                      </div>
                      <div v-else class="text-sm text-gray-500 dark:text-gray-400">No contact</div>
                    </td>
                    <td class="table-cell">
                      <div class="text-sm text-gray-900 dark:text-white">
                        {{ building.is_24_7 ? '24/7' : `${building.operating_hours_start} - ${building.operating_hours_end}` }}
                      </div>
                    </td>
                    <td class="table-cell">
                      <span :class="[
                        'badge',
                        building.status === 'ACTIVE' ? 'badge-success' :
                        building.status === 'INACTIVE' ? 'badge-secondary' : 'badge-warning'
                      ]">
                        {{ building.status }}
                      </span>
                    </td>
                    <td class="table-cell">
                      <div class="flex items-center space-x-2">
                        <button
                          @click="openBuildingModal(building)"
                          class="text-primary-600 hover:text-primary-900 dark:text-primary-400 dark:hover:text-primary-300"
                          title="Edit"
                        >
                          <i class="fas fa-edit"></i>
                        </button>
                        <button
                          @click="deleteBuilding(building)"
                          class="text-red-600 hover:text-red-900 dark:text-red-400 dark:hover:text-red-300"
                          title="Delete"
                        >
                          <i class="fas fa-trash"></i>
                        </button>
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <!-- Empty State -->
        <div v-if="buildings.length === 0" class="text-center py-12">
          <i class="fas fa-building text-4xl text-gray-400 mb-4"></i>
          <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">No buildings found</h3>
          <p class="text-gray-500 dark:text-gray-400 mb-4">Get started by adding your first building.</p>
          <button @click="openBuildingModal()" class="btn-primary">
            <i class="fas fa-plus mr-2"></i>
            Add Building
          </button>
        </div>
      </div>

      <!-- Departments Tab -->
      <div v-if="activeTab === 'departments'" class="space-y-6">
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-xl font-semibold text-gray-900 dark:text-white">Departments</h2>
            <p class="text-sm text-gray-500 dark:text-gray-400">Manage hospital departments and their requirements</p>
          </div>
          <button @click="openDepartmentModal()" class="btn-primary">
            <i class="fas fa-plus mr-2"></i>
            Add Department
          </button>
        </div>

        <!-- Departments content will be added here -->
        <div class="card">
          <div class="card-body">
            <p class="text-gray-500 dark:text-gray-400">Departments management coming soon...</p>
          </div>
        </div>
      </div>

      <!-- Other tabs placeholder -->
      <div v-if="!['buildings', 'departments'].includes(activeTab)" class="space-y-6">
        <div class="card">
          <div class="card-body">
            <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">{{ getCurrentTab()?.label }}</h3>
            <p class="text-gray-500 dark:text-gray-400">This section is under development.</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Building Modal -->
    <ModernModal
      :show="showBuildingModal"
      :title="editingBuilding ? 'Edit Building' : 'Add Building'"
      size="lg"
      :saving="isSubmitting"
      @close="closeBuildingModal"
      @save="saveBuildingModal"
    >
      <ModernBuildingForm
        ref="buildingFormRef"
        :building="editingBuilding"
        :is-submitting="isSubmitting"
        @submit="saveBuilding"
        @cancel="closeBuildingModal"
      />
    </ModernModal>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import ModernModal from './ModernModal.vue'
import ModernBuildingForm from './ModernBuildingForm.vue'

// Reactive data
const activeTab = ref('buildings')
const buildings = ref([])
const departments = ref([])
const services = ref([])
const porters = ref([])
const shifts = ref([])
const capabilities = ref([])
const allocations = ref([])
const availability = ref([])
const settings = ref([])

const showBuildingModal = ref(false)
const editingBuilding = ref(null)
const isSubmitting = ref(false)
const buildingFormRef = ref(null)

// Tab configuration
const tabs = computed(() => [
  { id: 'buildings', label: 'Buildings', icon: 'fas fa-building', count: buildings.value.length },
  { id: 'departments', label: 'Departments', icon: 'fas fa-sitemap', count: departments.value.length },
  { id: 'services', label: 'Services', icon: 'fas fa-concierge-bell', count: services.value.length },
  { id: 'porters', label: 'Porters', icon: 'fas fa-users', count: porters.value.length },
  { id: 'shifts', label: 'Shift Patterns', icon: 'fas fa-clock', count: shifts.value.length },
  { id: 'capabilities', label: 'Capabilities', icon: 'fas fa-certificate', count: capabilities.value.length },
  { id: 'allocations', label: 'Allocations', icon: 'fas fa-user-check', count: allocations.value.length },
  { id: 'availability', label: 'Availability', icon: 'fas fa-calendar-check', count: availability.value.length },
  { id: 'settings', label: 'Settings', icon: 'fas fa-cog' }
])

// Methods
const getCurrentTab = () => {
  return tabs.value.find(tab => tab.id === activeTab.value)
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

const openBuildingModal = (building = null) => {
  editingBuilding.value = building
  showBuildingModal.value = true
}

const closeBuildingModal = () => {
  showBuildingModal.value = false
  editingBuilding.value = null
  isSubmitting.value = false
}

const saveBuildingModal = () => {
  if (buildingFormRef.value) {
    buildingFormRef.value.handleSubmit()
  }
}

const saveBuilding = async (formData) => {
  isSubmitting.value = true
  try {
    const url = editingBuilding.value 
      ? `http://localhost:3001/api/buildings/${editingBuilding.value.id}`
      : 'http://localhost:3001/api/buildings'
    
    const method = editingBuilding.value ? 'PUT' : 'POST'
    
    const response = await fetch(url, {
      method,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(formData)
    })
    
    if (response.ok) {
      await fetchBuildings()
      closeBuildingModal()
    } else {
      const error = await response.json()
      alert(`Error: ${error.error || 'Failed to save building'}`)
    }
  } catch (error) {
    console.error('Error saving building:', error)
    alert('Failed to save building')
  } finally {
    isSubmitting.value = false
  }
}

const deleteBuilding = async (building) => {
  if (!confirm(`Are you sure you want to delete "${building.name}"?`)) {
    return
  }
  
  try {
    const response = await fetch(`http://localhost:3001/api/buildings/${building.id}`, {
      method: 'DELETE'
    })
    
    if (response.ok) {
      await fetchBuildings()
    } else {
      const error = await response.json()
      alert(`Error: ${error.error || 'Failed to delete building'}`)
    }
  } catch (error) {
    console.error('Error deleting building:', error)
    alert('Failed to delete building')
  }
}

const openDepartmentModal = () => {
  // TODO: Implement department modal
  alert('Department management coming soon!')
}

// Lifecycle
onMounted(() => {
  fetchBuildings()
})
</script>
