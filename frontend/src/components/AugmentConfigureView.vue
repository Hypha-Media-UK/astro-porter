<template>
  <div style="display: flex; flex-direction: column; gap: var(--space-8);">
    <!-- Header -->
    <div>
      <h1 style="font-size: var(--font-size-3xl); font-weight: var(--font-weight-bold); color: var(--color-text-primary); line-height: var(--line-height-tight);">Configuration</h1>
      <p style="color: var(--color-text-secondary); margin-top: var(--space-1);">Manage system settings, buildings, departments, porters, and services</p>
    </div>

    <!-- Tab Navigation -->
    <div>
      <nav style="display: flex; flex-wrap: wrap; gap: var(--space-1);">
        <button
          v-for="tab in tabs"
          :key="tab.id"
          @click="activeTab = tab.id"
          :class="[
            'btn',
            activeTab === tab.id ? 'btn-primary' : 'btn-ghost'
          ]"
          style="display: flex; align-items: center; gap: var(--space-2);"
        >
          <i :class="tab.icon"></i>
          {{ tab.label }}
        </button>
      </nav>
    </div>

    <!-- Tab Content -->
    <div class="card card-elevated">
      <div class="card-header">
        <h3 class="card-title">{{ getCurrentTab().label }}</h3>
        <p class="card-subtitle">{{ getCurrentTab().description }}</p>
      </div>
      <div class="card-body">
        <!-- Buildings Tab -->
        <div v-if="activeTab === 'buildings'">
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--space-6);">
            <div>
              <h4 style="font-size: var(--font-size-lg); font-weight: var(--font-weight-semibold); color: var(--color-text-primary);">Buildings</h4>
              <p style="color: var(--color-text-muted); font-size: var(--font-size-sm);">Manage hospital buildings and locations</p>
            </div>
            <button class="btn btn-primary">
              <i class="fas fa-plus"></i>
              Add Building
            </button>
          </div>
          
          <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: var(--space-4);">
            <div v-for="building in buildings" :key="building.id" class="card">
              <div style="padding: var(--space-4);">
                <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: var(--space-3);">
                  <div>
                    <h5 style="font-weight: var(--font-weight-semibold); color: var(--color-text-primary);">{{ building.name }}</h5>
                    <p style="font-size: var(--font-size-sm); color: var(--color-text-muted);">{{ building.address }}</p>
                  </div>
                  <div style="display: flex; gap: var(--space-1);">
                    <button class="btn btn-sm btn-ghost">
                      <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn btn-sm btn-ghost" style="color: var(--color-error-600);">
                      <i class="fas fa-trash"></i>
                    </button>
                  </div>
                </div>
                <div style="display: flex; justify-content: space-between; align-items: center;">
                  <span class="status-badge info">
                    {{ building.department_count || 0 }} Departments
                  </span>
                  <span style="font-size: var(--font-size-sm); color: var(--color-text-muted);">
                    {{ building.is_24_7 ? '24/7 Operation' : 'Standard Hours' }}
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Departments Tab -->
        <div v-if="activeTab === 'departments'">
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--space-6);">
            <div>
              <h4 style="font-size: var(--font-size-lg); font-weight: var(--font-weight-semibold); color: var(--color-text-primary);">Departments</h4>
              <p style="color: var(--color-text-muted); font-size: var(--font-size-sm);">Manage hospital departments and their staffing requirements</p>
            </div>
            <button class="btn btn-primary">
              <i class="fas fa-plus"></i>
              Add Department
            </button>
          </div>
          
          <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); gap: var(--space-4);">
            <div v-for="department in departments" :key="department.id" class="card">
              <div style="padding: var(--space-4);">
                <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: var(--space-3);">
                  <div>
                    <h5 style="font-weight: var(--font-weight-semibold); color: var(--color-text-primary);">{{ department.name }}</h5>
                    <p style="font-size: var(--font-size-sm); color: var(--color-text-muted);">{{ department.building_name }}</p>
                  </div>
                  <div style="display: flex; gap: var(--space-1);">
                    <button class="btn btn-sm btn-ghost">
                      <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn btn-sm btn-ghost" style="color: var(--color-error-600);">
                      <i class="fas fa-trash"></i>
                    </button>
                  </div>
                </div>
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--space-2);">
                  <span style="font-size: var(--font-size-sm); color: var(--color-text-muted);">
                    Required Porters: {{ department.required_porters }}
                  </span>
                  <span class="status-badge" :class="department.is_24_7 ? 'info' : 'warning'">
                    {{ department.is_24_7 ? '24/7' : 'Standard' }}
                  </span>
                </div>
                <div style="font-size: var(--font-size-xs); color: var(--color-text-muted);">
                  Priority: {{ department.priority_level }}
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Porters Tab -->
        <div v-if="activeTab === 'porters'">
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--space-6);">
            <div>
              <h4 style="font-size: var(--font-size-lg); font-weight: var(--font-weight-semibold); color: var(--color-text-primary);">Porters</h4>
              <p style="color: var(--color-text-muted); font-size: var(--font-size-sm);">Manage porter staff and their assignments</p>
            </div>
            <button class="btn btn-primary">
              <i class="fas fa-plus"></i>
              Add Porter
            </button>
          </div>
          
          <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: var(--space-4);">
            <div v-for="porter in porters.slice(0, 12)" :key="porter.id" class="card">
              <div style="padding: var(--space-4);">
                <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: var(--space-3);">
                  <div>
                    <h5 style="font-weight: var(--font-weight-semibold); color: var(--color-text-primary);">{{ porter.name }}</h5>
                    <p style="font-size: var(--font-size-sm); color: var(--color-text-muted);">{{ porter.employee_id }}</p>
                  </div>
                  <div style="display: flex; gap: var(--space-1);">
                    <button class="btn btn-sm btn-ghost">
                      <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn btn-sm btn-ghost" style="color: var(--color-error-600);">
                      <i class="fas fa-trash"></i>
                    </button>
                  </div>
                </div>
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--space-2);">
                  <span class="status-badge" :class="porter.is_supervisor ? 'success' : 'info'">
                    {{ porter.is_supervisor ? 'Supervisor' : 'Porter' }}
                  </span>
                  <span style="font-size: var(--font-size-sm); color: var(--color-text-muted);">
                    {{ porter.department_name }}
                  </span>
                </div>
                <div style="font-size: var(--font-size-xs); color: var(--color-text-muted);">
                  {{ porter.shift_pattern || 'No shift assigned' }}
                </div>
              </div>
            </div>
          </div>
          
          <div v-if="porters.length > 12" style="text-align: center; margin-top: var(--space-6);">
            <p style="color: var(--color-text-muted); font-size: var(--font-size-sm);">
              Showing 12 of {{ porters.length }} porters
            </p>
            <button class="btn btn-secondary" style="margin-top: var(--space-2);">
              View All Porters
            </button>
          </div>
        </div>

        <!-- Services Tab -->
        <div v-if="activeTab === 'services'">
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--space-6);">
            <div>
              <h4 style="font-size: var(--font-size-lg); font-weight: var(--font-weight-semibold); color: var(--color-text-primary);">Services</h4>
              <p style="color: var(--color-text-muted); font-size: var(--font-size-sm);">Manage porter services and specializations</p>
            </div>
            <button class="btn btn-primary">
              <i class="fas fa-plus"></i>
              Add Service
            </button>
          </div>
          
          <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: var(--space-4);">
            <div v-for="service in services" :key="service.id" class="card">
              <div style="padding: var(--space-4);">
                <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: var(--space-3);">
                  <div>
                    <h5 style="font-weight: var(--font-weight-semibold); color: var(--color-text-primary);">{{ service.name }}</h5>
                    <p style="font-size: var(--font-size-sm); color: var(--color-text-muted);">{{ service.description }}</p>
                  </div>
                  <div style="display: flex; gap: var(--space-1);">
                    <button class="btn btn-sm btn-ghost">
                      <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn btn-sm btn-ghost" style="color: var(--color-error-600);">
                      <i class="fas fa-trash"></i>
                    </button>
                  </div>
                </div>
                <div style="display: flex; justify-content: space-between; align-items: center;">
                  <span class="status-badge info">
                    {{ service.porter_count || 0 }} Porters
                  </span>
                  <span style="font-size: var(--font-size-sm); color: var(--color-text-muted);">
                    {{ service.is_active ? 'Active' : 'Inactive' }}
                  </span>
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
import { ref, computed, onMounted } from 'vue'

// Reactive data
const activeTab = ref('buildings')
const buildings = ref([])
const departments = ref([])
const porters = ref([])
const services = ref([])

// Tab configuration
const tabs = [
  { id: 'buildings', label: 'Buildings', icon: 'fas fa-building', description: 'Manage hospital buildings and locations' },
  { id: 'departments', label: 'Departments', icon: 'fas fa-sitemap', description: 'Configure departments and their staffing requirements' },
  { id: 'porters', label: 'Porters', icon: 'fas fa-users', description: 'Manage porter staff and assignments' },
  { id: 'services', label: 'Services', icon: 'fas fa-concierge-bell', description: 'Configure porter services and specializations' }
]

// Computed properties
const getCurrentTab = () => {
  return tabs.find(tab => tab.id === activeTab.value) || tabs[0]
}

// Methods
const fetchBuildings = async () => {
  try {
    const response = await fetch('http://localhost:3001/api/buildings')
    const data = await response.json()
    if (data.success) {
      buildings.value = data.data
    }
  } catch (error) {
    console.error('Error fetching buildings:', error)
  }
}

const fetchDepartments = async () => {
  try {
    const response = await fetch('http://localhost:3001/api/departments')
    const data = await response.json()
    if (data.success) {
      departments.value = data.data
    }
  } catch (error) {
    console.error('Error fetching departments:', error)
  }
}

const fetchPorters = async () => {
  try {
    const response = await fetch('http://localhost:3001/api/porters')
    const data = await response.json()
    if (data.success) {
      porters.value = data.data
    }
  } catch (error) {
    console.error('Error fetching porters:', error)
  }
}

const fetchServices = async () => {
  try {
    const response = await fetch('http://localhost:3001/api/services')
    const data = await response.json()
    if (data.success) {
      services.value = data.data
    }
  } catch (error) {
    console.error('Error fetching services:', error)
  }
}

// Lifecycle
onMounted(() => {
  fetchBuildings()
  fetchDepartments()
  fetchPorters()
  fetchServices()
})
</script>
