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

        <!-- Departments Table -->
        <div class="card">
          <div class="card-body p-0">
            <div class="overflow-x-auto">
              <table class="table">
                <thead>
                  <tr>
                    <th class="table-header-cell">Department</th>
                    <th class="table-header-cell">Building</th>
                    <th class="table-header-cell">Staffing Requirements</th>
                    <th class="table-header-cell">Manager</th>
                    <th class="table-header-cell">Status</th>
                    <th class="table-header-cell">Actions</th>
                  </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200 dark:bg-gray-800 dark:divide-gray-700">
                  <tr v-for="department in departments" :key="department.id" class="table-row">
                    <td class="table-cell">
                      <div class="flex items-center">
                        <div class="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center mr-3 dark:bg-blue-900">
                          <i class="fas fa-sitemap text-blue-600 text-sm dark:text-blue-300"></i>
                        </div>
                        <div>
                          <div class="text-sm font-medium text-gray-900 dark:text-white">{{ department.name }}</div>
                          <div class="text-sm text-gray-500 dark:text-gray-400">{{ department.location || 'No location specified' }}</div>
                        </div>
                      </div>
                    </td>
                    <td class="table-cell">
                      <div class="text-sm text-gray-900 dark:text-white">{{ department.building?.name || 'Unknown' }}</div>
                    </td>
                    <td class="table-cell">
                      <div class="text-sm text-gray-900 dark:text-white">
                        <div>Day: {{ department.required_porters_day || 0 }}</div>
                        <div>Evening: {{ department.required_porters_evening || 0 }}</div>
                        <div>Night: {{ department.required_porters_night || 0 }}</div>
                      </div>
                    </td>
                    <td class="table-cell">
                      <div v-if="department.manager_name" class="text-sm text-gray-900 dark:text-white">
                        {{ department.manager_name }}
                        <div v-if="department.contact_phone" class="text-sm text-gray-500 dark:text-gray-400">
                          {{ department.contact_phone }}
                        </div>
                      </div>
                      <div v-else class="text-sm text-gray-500 dark:text-gray-400">No manager assigned</div>
                    </td>
                    <td class="table-cell">
                      <span :class="[
                        'badge',
                        department.status === 'ACTIVE' ? 'badge-success' :
                        department.status === 'INACTIVE' ? 'badge-secondary' :
                        'badge-warning'
                      ]">
                        {{ department.status }}
                      </span>
                    </td>
                    <td class="table-cell">
                      <div class="flex items-center space-x-2">
                        <button @click="editDepartment(department)" class="btn-secondary btn-sm">
                          <i class="fas fa-edit"></i>
                        </button>
                        <button @click="deleteDepartment(department)" class="btn-danger btn-sm">
                          <i class="fas fa-trash"></i>
                        </button>
                      </div>
                    </td>
                  </tr>
                  <tr v-if="departments.length === 0">
                    <td colspan="6" class="table-cell text-center text-gray-500 dark:text-gray-400">
                      No departments found. Click "Add Department" to create your first department.
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>

      <!-- Porters Tab -->
      <div v-if="activeTab === 'porters'" class="space-y-6">
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-xl font-semibold text-gray-900 dark:text-white">Porters</h2>
            <p class="text-sm text-gray-500 dark:text-gray-400">Manage hospital porters and their assignments</p>
          </div>
          <button @click="openPorterModal()" class="btn-primary">
            <i class="fas fa-plus mr-2"></i>
            Add Porter
          </button>
        </div>

        <!-- Porters Table -->
        <div class="card">
          <div class="card-body p-0">
            <div class="overflow-x-auto">
              <table class="table">
                <thead>
                  <tr>
                    <th class="table-header-cell">Porter</th>
                    <th class="table-header-cell">Type</th>
                    <th class="table-header-cell">Contract</th>
                    <th class="table-header-cell">Department</th>
                    <th class="table-header-cell">Contact</th>
                    <th class="table-header-cell">Status</th>
                    <th class="table-header-cell">Actions</th>
                  </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200 dark:bg-gray-800 dark:divide-gray-700">
                  <tr v-for="porter in porters" :key="porter.id" class="table-row">
                    <td class="table-cell">
                      <div class="flex items-center">
                        <div class="w-8 h-8 bg-green-100 rounded-lg flex items-center justify-center mr-3 dark:bg-green-900">
                          <i class="fas fa-user text-green-600 text-sm dark:text-green-300"></i>
                        </div>
                        <div>
                          <div class="text-sm font-medium text-gray-900 dark:text-white">{{ porter.name }}</div>
                          <div class="text-sm text-gray-500 dark:text-gray-400">{{ porter.employee_id || 'No ID' }}</div>
                        </div>
                      </div>
                    </td>
                    <td class="table-cell">
                      <div class="text-sm text-gray-900 dark:text-white">{{ porter.porter_type?.replace('_', ' ') || 'General' }}</div>
                    </td>
                    <td class="table-cell">
                      <div class="text-sm text-gray-900 dark:text-white">{{ porter.contract_type?.replace('_', ' ') || 'Unknown' }}</div>
                    </td>
                    <td class="table-cell">
                      <div class="text-sm text-gray-900 dark:text-white">{{ porter.regularDepartment?.name || 'Unassigned' }}</div>
                    </td>
                    <td class="table-cell">
                      <div v-if="porter.email || porter.phone" class="text-sm text-gray-900 dark:text-white">
                        <div v-if="porter.email">{{ porter.email }}</div>
                        <div v-if="porter.phone" class="text-sm text-gray-500 dark:text-gray-400">{{ porter.phone }}</div>
                      </div>
                      <div v-else class="text-sm text-gray-500 dark:text-gray-400">No contact info</div>
                    </td>
                    <td class="table-cell">
                      <span :class="[
                        'badge',
                        porter.status === 'ACTIVE' ? 'badge-success' :
                        porter.status === 'INACTIVE' ? 'badge-secondary' :
                        porter.status === 'ON_LEAVE' ? 'badge-warning' :
                        'badge-danger'
                      ]">
                        {{ porter.status?.replace('_', ' ') }}
                      </span>
                    </td>
                    <td class="table-cell">
                      <div class="flex items-center space-x-2">
                        <button @click="editPorter(porter)" class="btn-secondary btn-sm">
                          <i class="fas fa-edit"></i>
                        </button>
                        <button @click="deletePorter(porter)" class="btn-danger btn-sm">
                          <i class="fas fa-trash"></i>
                        </button>
                      </div>
                    </td>
                  </tr>
                  <tr v-if="porters.length === 0">
                    <td colspan="7" class="table-cell text-center text-gray-500 dark:text-gray-400">
                      No porters found. Click "Add Porter" to create your first porter.
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>

      <!-- Services Tab -->
      <div v-if="activeTab === 'services'" class="space-y-6">
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-xl font-semibold text-gray-900 dark:text-white">Services</h2>
            <p class="text-sm text-gray-500 dark:text-gray-400">Manage hospital services and their requirements</p>
          </div>
          <button @click="openServiceModal()" class="btn-primary">
            <i class="fas fa-plus mr-2"></i>
            Add Service
          </button>
        </div>

        <!-- Services Table -->
        <div class="card">
          <div class="card-body p-0">
            <div class="overflow-x-auto">
              <table class="table">
                <thead>
                  <tr>
                    <th class="table-header-cell">Service</th>
                    <th class="table-header-cell">Department</th>
                    <th class="table-header-cell">Type</th>
                    <th class="table-header-cell">Priority</th>
                    <th class="table-header-cell">Requirements</th>
                    <th class="table-header-cell">Status</th>
                    <th class="table-header-cell">Actions</th>
                  </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200 dark:bg-gray-800 dark:divide-gray-700">
                  <tr v-for="service in services" :key="service.id" class="table-row">
                    <td class="table-cell">
                      <div class="flex items-center">
                        <div class="w-8 h-8 bg-purple-100 rounded-lg flex items-center justify-center mr-3 dark:bg-purple-900">
                          <i class="fas fa-concierge-bell text-purple-600 text-sm dark:text-purple-300"></i>
                        </div>
                        <div>
                          <div class="text-sm font-medium text-gray-900 dark:text-white">{{ service.name }}</div>
                          <div class="text-sm text-gray-500 dark:text-gray-400">{{ service.location || 'No location' }}</div>
                        </div>
                      </div>
                    </td>
                    <td class="table-cell">
                      <div class="text-sm text-gray-900 dark:text-white">{{ service.department?.name || 'Unknown' }}</div>
                    </td>
                    <td class="table-cell">
                      <div class="text-sm text-gray-900 dark:text-white">{{ service.service_type?.replace('_', ' ') || 'General' }}</div>
                    </td>
                    <td class="table-cell">
                      <span :class="[
                        'badge',
                        service.priority_level === 'EMERGENCY' ? 'badge-danger' :
                        service.priority_level === 'URGENT' ? 'badge-warning' :
                        service.priority_level === 'HIGH' ? 'badge-warning' :
                        service.priority_level === 'MEDIUM' ? 'badge-info' :
                        'badge-secondary'
                      ]">
                        {{ service.priority_level }}
                      </span>
                    </td>
                    <td class="table-cell">
                      <div class="text-sm text-gray-900 dark:text-white">
                        <div>{{ service.required_porters || 1 }} porter{{ (service.required_porters || 1) > 1 ? 's' : '' }}</div>
                        <div class="text-sm text-gray-500 dark:text-gray-400">{{ service.estimated_duration || 15 }}min</div>
                      </div>
                    </td>
                    <td class="table-cell">
                      <span :class="[
                        'badge',
                        service.status === 'ACTIVE' ? 'badge-success' :
                        service.status === 'INACTIVE' ? 'badge-secondary' :
                        service.status === 'SUSPENDED' ? 'badge-danger' :
                        'badge-warning'
                      ]">
                        {{ service.status }}
                      </span>
                    </td>
                    <td class="table-cell">
                      <div class="flex items-center space-x-2">
                        <button @click="editService(service)" class="btn-secondary btn-sm">
                          <i class="fas fa-edit"></i>
                        </button>
                        <button @click="deleteService(service)" class="btn-danger btn-sm">
                          <i class="fas fa-trash"></i>
                        </button>
                      </div>
                    </td>
                  </tr>
                  <tr v-if="services.length === 0">
                    <td colspan="7" class="table-cell text-center text-gray-500 dark:text-gray-400">
                      No services found. Click "Add Service" to create your first service.
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>

      <!-- Shift Patterns Tab -->
      <div v-if="activeTab === 'shifts'" class="space-y-6">
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-xl font-semibold text-gray-900 dark:text-white">Shift Patterns</h2>
            <p class="text-sm text-gray-500 dark:text-gray-400">Configure shift patterns and schedules</p>
          </div>
          <button @click="openShiftPatternModal()" class="btn-primary">
            <i class="fas fa-plus mr-2"></i>
            Add Shift Pattern
          </button>
        </div>

        <!-- Shift Patterns Table -->
        <div class="card">
          <div class="card-body p-0">
            <div class="overflow-x-auto">
              <table class="table">
                <thead>
                  <tr>
                    <th class="table-header-cell">Pattern</th>
                    <th class="table-header-cell">Type</th>
                    <th class="table-header-cell">Time</th>
                    <th class="table-header-cell">Duration</th>
                    <th class="table-header-cell">Working Days</th>
                    <th class="table-header-cell">Status</th>
                    <th class="table-header-cell">Actions</th>
                  </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200 dark:bg-gray-800 dark:divide-gray-700">
                  <tr v-for="pattern in shifts" :key="pattern.id" class="table-row">
                    <td class="table-cell">
                      <div class="flex items-center">
                        <div
                          class="w-4 h-4 rounded mr-3"
                          :style="{ backgroundColor: pattern.color_code || '#3B82F6' }"
                        ></div>
                        <div>
                          <div class="text-sm font-medium text-gray-900 dark:text-white">{{ pattern.name }}</div>
                          <div class="text-sm text-gray-500 dark:text-gray-400">{{ pattern.description || 'No description' }}</div>
                        </div>
                      </div>
                    </td>
                    <td class="table-cell">
                      <div class="text-sm text-gray-900 dark:text-white">{{ pattern.shift_type?.replace('_', ' ') || 'Day' }}</div>
                    </td>
                    <td class="table-cell">
                      <div class="text-sm text-gray-900 dark:text-white">
                        {{ pattern.start_time || '07:00' }} - {{ pattern.end_time || '15:00' }}
                      </div>
                    </td>
                    <td class="table-cell">
                      <div class="text-sm text-gray-900 dark:text-white">{{ pattern.duration_hours || 8 }}h</div>
                    </td>
                    <td class="table-cell">
                      <div class="text-sm text-gray-900 dark:text-white">
                        {{ (pattern.working_days || []).length }} days/week
                      </div>
                    </td>
                    <td class="table-cell">
                      <span :class="[
                        'badge',
                        pattern.status === 'ACTIVE' ? 'badge-success' :
                        pattern.status === 'INACTIVE' ? 'badge-secondary' :
                        pattern.status === 'DRAFT' ? 'badge-warning' :
                        'badge-secondary'
                      ]">
                        {{ pattern.status }}
                      </span>
                    </td>
                    <td class="table-cell">
                      <div class="flex items-center space-x-2">
                        <button @click="editShiftPattern(pattern)" class="btn-secondary btn-sm">
                          <i class="fas fa-edit"></i>
                        </button>
                        <button @click="deleteShiftPattern(pattern)" class="btn-danger btn-sm">
                          <i class="fas fa-trash"></i>
                        </button>
                      </div>
                    </td>
                  </tr>
                  <tr v-if="shifts.length === 0">
                    <td colspan="7" class="table-cell text-center text-gray-500 dark:text-gray-400">
                      No shift patterns found. Click "Add Shift Pattern" to create your first pattern.
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>

      <!-- Capabilities Tab -->
      <div v-if="activeTab === 'capabilities'" class="space-y-6">
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-xl font-semibold text-gray-900 dark:text-white">Capabilities</h2>
            <p class="text-sm text-gray-500 dark:text-gray-400">Manage porter capabilities and certifications</p>
          </div>
          <button @click="openCapabilityModal()" class="btn-primary">
            <i class="fas fa-plus mr-2"></i>
            Add Capability
          </button>
        </div>

        <!-- Capabilities Table -->
        <div class="card">
          <div class="card-body p-0">
            <div class="overflow-x-auto">
              <table class="table">
                <thead>
                  <tr>
                    <th class="table-header-cell">Capability</th>
                    <th class="table-header-cell">Category</th>
                    <th class="table-header-cell">Certification</th>
                    <th class="table-header-cell">Risk Level</th>
                    <th class="table-header-cell">Training</th>
                    <th class="table-header-cell">Status</th>
                    <th class="table-header-cell">Actions</th>
                  </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200 dark:bg-gray-800 dark:divide-gray-700">
                  <tr v-for="capability in capabilities" :key="capability.id" class="table-row">
                    <td class="table-cell">
                      <div class="flex items-center">
                        <div class="w-8 h-8 bg-green-100 rounded-lg flex items-center justify-center mr-3 dark:bg-green-900">
                          <i class="fas fa-certificate text-green-600 text-sm dark:text-green-300"></i>
                        </div>
                        <div>
                          <div class="text-sm font-medium text-gray-900 dark:text-white">{{ capability.name }}</div>
                          <div class="text-sm text-gray-500 dark:text-gray-400">{{ capability.description || 'No description' }}</div>
                        </div>
                      </div>
                    </td>
                    <td class="table-cell">
                      <div class="text-sm text-gray-900 dark:text-white">{{ capability.category?.replace('_', ' ') || 'General' }}</div>
                    </td>
                    <td class="table-cell">
                      <span :class="[
                        'badge',
                        capability.certification_required === 'PROFESSIONAL' ? 'badge-danger' :
                        capability.certification_required === 'ADVANCED' ? 'badge-warning' :
                        capability.certification_required === 'INTERMEDIATE' ? 'badge-info' :
                        capability.certification_required === 'BASIC' ? 'badge-secondary' :
                        'badge-success'
                      ]">
                        {{ capability.certification_required?.replace('_', ' ') || 'None' }}
                      </span>
                    </td>
                    <td class="table-cell">
                      <span :class="[
                        'badge',
                        capability.risk_level === 'CRITICAL' ? 'badge-danger' :
                        capability.risk_level === 'HIGH' ? 'badge-warning' :
                        capability.risk_level === 'MEDIUM' ? 'badge-info' :
                        'badge-success'
                      ]">
                        {{ capability.risk_level }}
                      </span>
                    </td>
                    <td class="table-cell">
                      <div class="text-sm text-gray-900 dark:text-white">
                        <div>{{ capability.training_hours || 0 }}h training</div>
                        <div class="text-sm text-gray-500 dark:text-gray-400">{{ capability.renewal_period || 12 }}mo renewal</div>
                      </div>
                    </td>
                    <td class="table-cell">
                      <span :class="[
                        'badge',
                        capability.status === 'ACTIVE' ? 'badge-success' :
                        capability.status === 'INACTIVE' ? 'badge-secondary' :
                        capability.status === 'UNDER_REVIEW' ? 'badge-warning' :
                        'badge-secondary'
                      ]">
                        {{ capability.status?.replace('_', ' ') }}
                      </span>
                    </td>
                    <td class="table-cell">
                      <div class="flex items-center space-x-2">
                        <button @click="editCapability(capability)" class="btn-secondary btn-sm">
                          <i class="fas fa-edit"></i>
                        </button>
                        <button @click="deleteCapability(capability)" class="btn-danger btn-sm">
                          <i class="fas fa-trash"></i>
                        </button>
                      </div>
                    </td>
                  </tr>
                  <tr v-if="capabilities.length === 0">
                    <td colspan="7" class="table-cell text-center text-gray-500 dark:text-gray-400">
                      No capabilities found. Click "Add Capability" to create your first capability.
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>

      <!-- Allocations Tab -->
      <div v-if="activeTab === 'allocations'" class="space-y-6">
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-xl font-semibold text-gray-900 dark:text-white">Allocations</h2>
            <p class="text-sm text-gray-500 dark:text-gray-400">Manage porter allocations and scheduling</p>
          </div>
          <button @click="openAllocationModal()" class="btn-primary">
            <i class="fas fa-plus mr-2"></i>
            Add Allocation
          </button>
        </div>

        <!-- Allocations Table -->
        <div class="card">
          <div class="card-body p-0">
            <div class="overflow-x-auto">
              <table class="table">
                <thead>
                  <tr>
                    <th class="table-header-cell">Porter</th>
                    <th class="table-header-cell">Department</th>
                    <th class="table-header-cell">Date & Time</th>
                    <th class="table-header-cell">Type</th>
                    <th class="table-header-cell">Priority</th>
                    <th class="table-header-cell">Status</th>
                    <th class="table-header-cell">Actions</th>
                  </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200 dark:bg-gray-800 dark:divide-gray-700">
                  <tr v-for="allocation in allocations" :key="allocation.id" class="table-row">
                    <td class="table-cell">
                      <div class="flex items-center">
                        <div class="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center mr-3 dark:bg-blue-900">
                          <i class="fas fa-user text-blue-600 text-sm dark:text-blue-300"></i>
                        </div>
                        <div>
                          <div class="text-sm font-medium text-gray-900 dark:text-white">{{ allocation.porter?.name || 'Unknown' }}</div>
                          <div class="text-sm text-gray-500 dark:text-gray-400">{{ allocation.porter?.employee_id || 'N/A' }}</div>
                        </div>
                      </div>
                    </td>
                    <td class="table-cell">
                      <div class="text-sm text-gray-900 dark:text-white">{{ allocation.department?.name || 'Unknown' }}</div>
                      <div class="text-sm text-gray-500 dark:text-gray-400">{{ allocation.location || 'No location' }}</div>
                    </td>
                    <td class="table-cell">
                      <div class="text-sm text-gray-900 dark:text-white">{{ allocation.allocation_date || 'No date' }}</div>
                      <div class="text-sm text-gray-500 dark:text-gray-400">{{ allocation.start_time || '00:00' }} - {{ allocation.end_time || '00:00' }}</div>
                    </td>
                    <td class="table-cell">
                      <span :class="[
                        'badge',
                        allocation.allocation_type === 'EMERGENCY' ? 'badge-danger' :
                        allocation.allocation_type === 'OVERTIME' ? 'badge-warning' :
                        allocation.allocation_type === 'TEMPORARY' ? 'badge-info' :
                        'badge-secondary'
                      ]">
                        {{ allocation.allocation_type?.replace('_', ' ') || 'Regular' }}
                      </span>
                    </td>
                    <td class="table-cell">
                      <span :class="[
                        'badge',
                        allocation.priority === 'EMERGENCY' ? 'badge-danger' :
                        allocation.priority === 'URGENT' ? 'badge-warning' :
                        allocation.priority === 'HIGH' ? 'badge-warning' :
                        allocation.priority === 'MEDIUM' ? 'badge-info' :
                        'badge-secondary'
                      ]">
                        {{ allocation.priority }}
                      </span>
                    </td>
                    <td class="table-cell">
                      <span :class="[
                        'badge',
                        allocation.status === 'CONFIRMED' ? 'badge-success' :
                        allocation.status === 'IN_PROGRESS' ? 'badge-info' :
                        allocation.status === 'COMPLETED' ? 'badge-success' :
                        allocation.status === 'CANCELLED' ? 'badge-danger' :
                        allocation.status === 'NO_SHOW' ? 'badge-danger' :
                        'badge-warning'
                      ]">
                        {{ allocation.status?.replace('_', ' ') }}
                      </span>
                    </td>
                    <td class="table-cell">
                      <div class="flex items-center space-x-2">
                        <button @click="editAllocation(allocation)" class="btn-secondary btn-sm">
                          <i class="fas fa-edit"></i>
                        </button>
                        <button @click="deleteAllocation(allocation)" class="btn-danger btn-sm">
                          <i class="fas fa-trash"></i>
                        </button>
                      </div>
                    </td>
                  </tr>
                  <tr v-if="allocations.length === 0">
                    <td colspan="7" class="table-cell text-center text-gray-500 dark:text-gray-400">
                      No allocations found. Click "Add Allocation" to create your first allocation.
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>

      <!-- Availability Tab -->
      <div v-if="activeTab === 'availability'" class="space-y-6">
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-xl font-semibold text-gray-900 dark:text-white">Availability</h2>
            <p class="text-sm text-gray-500 dark:text-gray-400">Manage porter availability and scheduling preferences</p>
          </div>
          <button @click="openAvailabilityModal()" class="btn-primary">
            <i class="fas fa-plus mr-2"></i>
            Add Availability
          </button>
        </div>

        <!-- Availability Table -->
        <div class="card">
          <div class="card-body p-0">
            <div class="overflow-x-auto">
              <table class="table">
                <thead>
                  <tr>
                    <th class="table-header-cell">Porter</th>
                    <th class="table-header-cell">Type</th>
                    <th class="table-header-cell">Date Range</th>
                    <th class="table-header-cell">Time Range</th>
                    <th class="table-header-cell">Days</th>
                    <th class="table-header-cell">Status</th>
                    <th class="table-header-cell">Actions</th>
                  </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200 dark:bg-gray-800 dark:divide-gray-700">
                  <tr v-for="availability in availabilities" :key="availability.id" class="table-row">
                    <td class="table-cell">
                      <div class="flex items-center">
                        <div class="w-8 h-8 bg-indigo-100 rounded-lg flex items-center justify-center mr-3 dark:bg-indigo-900">
                          <i class="fas fa-calendar-check text-indigo-600 text-sm dark:text-indigo-300"></i>
                        </div>
                        <div>
                          <div class="text-sm font-medium text-gray-900 dark:text-white">{{ availability.porter?.name || 'Unknown' }}</div>
                          <div class="text-sm text-gray-500 dark:text-gray-400">{{ availability.porter?.employee_id || 'N/A' }}</div>
                        </div>
                      </div>
                    </td>
                    <td class="table-cell">
                      <span :class="[
                        'badge',
                        availability.availability_type === 'AVAILABLE' ? 'badge-success' :
                        availability.availability_type === 'UNAVAILABLE' ? 'badge-danger' :
                        availability.availability_type === 'PREFERRED' ? 'badge-info' :
                        availability.availability_type === 'LIMITED' ? 'badge-warning' :
                        'badge-secondary'
                      ]">
                        {{ availability.availability_type?.replace('_', ' ') || 'Available' }}
                      </span>
                    </td>
                    <td class="table-cell">
                      <div class="text-sm text-gray-900 dark:text-white">{{ availability.start_date || 'No start' }}</div>
                      <div class="text-sm text-gray-500 dark:text-gray-400">{{ availability.end_date || 'Ongoing' }}</div>
                    </td>
                    <td class="table-cell">
                      <div class="text-sm text-gray-900 dark:text-white">
                        {{ availability.start_time || 'All day' }} {{ availability.end_time ? '- ' + availability.end_time : '' }}
                      </div>
                    </td>
                    <td class="table-cell">
                      <div class="text-sm text-gray-900 dark:text-white">
                        {{ (availability.days_of_week || []).length }} days/week
                      </div>
                    </td>
                    <td class="table-cell">
                      <span :class="[
                        'badge',
                        availability.status === 'APPROVED' ? 'badge-success' :
                        availability.status === 'PENDING' ? 'badge-warning' :
                        availability.status === 'REJECTED' ? 'badge-danger' :
                        availability.status === 'CANCELLED' ? 'badge-secondary' :
                        'badge-info'
                      ]">
                        {{ availability.status }}
                      </span>
                    </td>
                    <td class="table-cell">
                      <div class="flex items-center space-x-2">
                        <button @click="editAvailability(availability)" class="btn-secondary btn-sm">
                          <i class="fas fa-edit"></i>
                        </button>
                        <button @click="deleteAvailability(availability)" class="btn-danger btn-sm">
                          <i class="fas fa-trash"></i>
                        </button>
                      </div>
                    </td>
                  </tr>
                  <tr v-if="availabilities.length === 0">
                    <td colspan="7" class="table-cell text-center text-gray-500 dark:text-gray-400">
                      No availability records found. Click "Add Availability" to create your first record.
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>

      <!-- Settings Tab -->
      <div v-if="activeTab === 'settings'" class="space-y-6">
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-xl font-semibold text-gray-900 dark:text-white">System Settings</h2>
            <p class="text-sm text-gray-500 dark:text-gray-400">Configure system-wide settings and preferences</p>
          </div>
          <button @click="saveSettings()" class="btn-primary" :disabled="isSubmitting">
            <i class="fas fa-save mr-2"></i>
            {{ isSubmitting ? 'Saving...' : 'Save Settings' }}
          </button>
        </div>

        <!-- Settings Form -->
        <ModernSettingsForm
          ref="settingsFormRef"
          :settings="systemSettings"
          @submit="handleSettingsSubmit"
        />
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

    <!-- Department Modal -->
    <ModernModal
      v-if="showDepartmentModal"
      :show="showDepartmentModal"
      :title="editingDepartment ? 'Edit Department' : 'Add Department'"
      size="lg"
      :saving="isSubmitting"
      @close="closeDepartmentModal"
      @save="saveDepartmentModal"
    >
      <ModernDepartmentForm
        ref="departmentFormRef"
        :department="editingDepartment"
        :buildings="buildings"
        @submit="handleDepartmentSubmit"
      />
    </ModernModal>

    <!-- Porter Modal -->
    <ModernModal
      v-if="showPorterModal"
      :show="showPorterModal"
      :title="editingPorter ? 'Edit Porter' : 'Add Porter'"
      size="lg"
      :saving="isSubmitting"
      @close="closePorterModal"
      @save="savePorterModal"
    >
      <ModernPorterForm
        ref="porterFormRef"
        :porter="editingPorter"
        :departments="departments"
        :shift-patterns="shifts"
        @submit="handlePorterSubmit"
      />
    </ModernModal>

    <!-- Service Modal -->
    <ModernModal
      v-if="showServiceModal"
      :show="showServiceModal"
      :title="editingService ? 'Edit Service' : 'Add Service'"
      size="lg"
      :saving="isSubmitting"
      @close="closeServiceModal"
      @save="saveServiceModal"
    >
      <ModernServiceForm
        ref="serviceFormRef"
        :service="editingService"
        :departments="departments"
        @submit="handleServiceSubmit"
      />
    </ModernModal>

    <!-- Shift Pattern Modal -->
    <ModernModal
      v-if="showShiftPatternModal"
      :show="showShiftPatternModal"
      :title="editingShiftPattern ? 'Edit Shift Pattern' : 'Add Shift Pattern'"
      size="lg"
      :saving="isSubmitting"
      @close="closeShiftPatternModal"
      @save="saveShiftPatternModal"
    >
      <ModernShiftPatternForm
        ref="shiftPatternFormRef"
        :shift-pattern="editingShiftPattern"
        @submit="handleShiftPatternSubmit"
      />
    </ModernModal>

    <!-- Capability Modal -->
    <ModernModal
      v-if="showCapabilityModal"
      :show="showCapabilityModal"
      :title="editingCapability ? 'Edit Capability' : 'Add Capability'"
      size="lg"
      :saving="isSubmitting"
      @close="closeCapabilityModal"
      @save="saveCapabilityModal"
    >
      <ModernCapabilityForm
        ref="capabilityFormRef"
        :capability="editingCapability"
        @submit="handleCapabilitySubmit"
      />
    </ModernModal>

    <!-- Allocation Modal -->
    <ModernModal
      v-if="showAllocationModal"
      :show="showAllocationModal"
      :title="editingAllocation ? 'Edit Allocation' : 'Add Allocation'"
      size="lg"
      :saving="isSubmitting"
      @close="closeAllocationModal"
      @save="saveAllocationModal"
    >
      <ModernAllocationForm
        ref="allocationFormRef"
        :allocation="editingAllocation"
        :porters="porters"
        :departments="departments"
        :services="services"
        :shift-patterns="shifts"
        @submit="handleAllocationSubmit"
      />
    </ModernModal>

    <!-- Availability Modal -->
    <ModernModal
      v-if="showAvailabilityModal"
      :show="showAvailabilityModal"
      :title="editingAvailability ? 'Edit Availability' : 'Add Availability'"
      size="lg"
      :saving="isSubmitting"
      @close="closeAvailabilityModal"
      @save="saveAvailabilityModal"
    >
      <ModernAvailabilityForm
        ref="availabilityFormRef"
        :availability="editingAvailability"
        :porters="porters"
        :departments="departments"
        @submit="handleAvailabilitySubmit"
      />
    </ModernModal>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import ModernModal from './ModernModal.vue'
import ModernBuildingForm from './ModernBuildingForm.vue'
import ModernDepartmentForm from './ModernDepartmentForm.vue'
import ModernPorterForm from './ModernPorterForm.vue'
import ModernServiceForm from './ModernServiceForm.vue'
import ModernShiftPatternForm from './ModernShiftPatternForm.vue'
import ModernCapabilityForm from './ModernCapabilityForm.vue'
import ModernAllocationForm from './ModernAllocationForm.vue'
import ModernAvailabilityForm from './ModernAvailabilityForm.vue'
import ModernSettingsForm from './ModernSettingsForm.vue'

// Reactive data
const activeTab = ref('buildings')
const buildings = ref([])
const departments = ref([])
const services = ref([])
const porters = ref([])
const shiftPatterns = ref([])
const capabilities = ref([])
const allocations = ref([])
const availabilities = ref([])
const settings = ref([])

const showBuildingModal = ref(false)
const editingBuilding = ref(null)
const showDepartmentModal = ref(false)
const editingDepartment = ref(null)
const showPorterModal = ref(false)
const editingPorter = ref(null)
const showServiceModal = ref(false)
const editingService = ref(null)
const showShiftPatternModal = ref(false)
const editingShiftPattern = ref(null)
const showCapabilityModal = ref(false)
const editingCapability = ref(null)
const showAllocationModal = ref(false)
const editingAllocation = ref(null)
const showAvailabilityModal = ref(false)
const editingAvailability = ref(null)
const isSubmitting = ref(false)
const buildingFormRef = ref(null)
const departmentFormRef = ref(null)
const porterFormRef = ref(null)
const serviceFormRef = ref(null)
const shiftPatternFormRef = ref(null)
const capabilityFormRef = ref(null)
const allocationFormRef = ref(null)
const availabilityFormRef = ref(null)
const settingsFormRef = ref(null)
const systemSettings = ref({})

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

const fetchDepartments = async () => {
  try {
    const response = await fetch('http://localhost:3001/api/departments')
    if (response.ok) {
      const data = await response.json()
      departments.value = data.data || []
    }
  } catch (error) {
    console.error('Error fetching departments:', error)
  }
}

const fetchPorters = async () => {
  try {
    const response = await fetch('http://localhost:3001/api/porters')
    if (response.ok) {
      const data = await response.json()
      porters.value = data.data || []
    }
  } catch (error) {
    console.error('Error fetching porters:', error)
  }
}

const fetchServices = async () => {
  try {
    const response = await fetch('http://localhost:3001/api/services')
    if (response.ok) {
      const data = await response.json()
      services.value = data.data || []
    }
  } catch (error) {
    console.error('Error fetching services:', error)
  }
}

const fetchShiftPatterns = async () => {
  try {
    const response = await fetch('http://localhost:3001/api/shift-patterns')
    if (response.ok) {
      const data = await response.json()
      shifts.value = data.data || []
    }
  } catch (error) {
    console.error('Error fetching shift patterns:', error)
  }
}

const fetchCapabilities = async () => {
  try {
    const response = await fetch('http://localhost:3001/api/capabilities')
    if (response.ok) {
      const data = await response.json()
      capabilities.value = data.data || []
    }
  } catch (error) {
    console.error('Error fetching capabilities:', error)
  }
}

const fetchAllocations = async () => {
  try {
    const response = await fetch('http://localhost:3001/api/allocations')
    if (response.ok) {
      const data = await response.json()
      allocations.value = data.data || []
    }
  } catch (error) {
    console.error('Error fetching allocations:', error)
  }
}

const fetchAvailabilities = async () => {
  try {
    // For now, use mock data since the API endpoint doesn't exist yet
    availabilities.value = [
      {
        id: '1',
        porter_id: 'porter1',
        porter: { name: 'John Smith', employee_id: 'EMP001' },
        availability_type: 'AVAILABLE',
        start_date: '2024-01-15',
        end_date: '2024-01-20',
        start_time: '07:00',
        end_time: '15:00',
        days_of_week: ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY'],
        recurring_pattern: 'WEEKLY',
        status: 'APPROVED'
      },
      {
        id: '2',
        porter_id: 'porter2',
        porter: { name: 'Sarah Johnson', employee_id: 'EMP002' },
        availability_type: 'UNAVAILABLE',
        start_date: '2024-01-22',
        end_date: '2024-01-26',
        start_time: '',
        end_time: '',
        days_of_week: [],
        recurring_pattern: 'NONE',
        status: 'PENDING'
      }
    ]
  } catch (error) {
    console.error('Error fetching availabilities:', error)
  }
}

const fetchSettings = async () => {
  try {
    // For now, use default settings since the API endpoint doesn't exist yet
    systemSettings.value = {
      system_name: 'Porter Management System',
      organization_name: 'NHS Trust Hospital',
      timezone: 'Europe/London',
      date_format: 'DD/MM/YYYY',
      default_shift_duration: 8,
      min_break_duration: 15,
      max_consecutive_days: 7,
      overtime_rate: 1.5,
      night_allowance: 15.00,
      email_notifications: true,
      sms_notifications: false,
      shift_reminders: true,
      reminder_hours: 2,
      admin_email: 'admin@hospital.nhs.uk',
      min_coverage_percentage: 80,
      critical_threshold: 50,
      auto_assign_priority: 'MEDIUM',
      data_retention_months: 24,
      backup_frequency: 'DAILY',
      audit_logging: true,
      gdpr_compliance: true,
      hr_api_endpoint: '',
      payroll_integration: 'DISABLED'
    }
  } catch (error) {
    console.error('Error fetching settings:', error)
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
  editingDepartment.value = null
  showDepartmentModal.value = true
}

const closeDepartmentModal = () => {
  showDepartmentModal.value = false
  editingDepartment.value = null
  if (departmentFormRef.value) {
    departmentFormRef.value.resetForm()
  }
}

const editDepartment = (department) => {
  editingDepartment.value = department
  showDepartmentModal.value = true
}

const saveDepartmentModal = () => {
  if (departmentFormRef.value) {
    departmentFormRef.value.handleSubmit()
  }
}

const handleDepartmentSubmit = async (formData) => {
  isSubmitting.value = true

  try {
    const url = editingDepartment.value
      ? `http://localhost:3001/api/departments/${editingDepartment.value.id}`
      : 'http://localhost:3001/api/departments'

    const method = editingDepartment.value ? 'PUT' : 'POST'

    const response = await fetch(url, {
      method,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(formData)
    })

    if (response.ok) {
      await fetchDepartments()
      closeDepartmentModal()
    } else {
      const error = await response.json()
      alert(`Error: ${error.error || 'Failed to save department'}`)
    }
  } catch (error) {
    console.error('Error saving department:', error)
    alert('Failed to save department')
  } finally {
    isSubmitting.value = false
  }
}

const deleteDepartment = async (department) => {
  if (!confirm(`Are you sure you want to delete "${department.name}"?`)) {
    return
  }

  try {
    const response = await fetch(`http://localhost:3001/api/departments/${department.id}`, {
      method: 'DELETE'
    })

    if (response.ok) {
      await fetchDepartments()
    } else {
      const error = await response.json()
      alert(`Error: ${error.error || 'Failed to delete department'}`)
    }
  } catch (error) {
    console.error('Error deleting department:', error)
    alert('Failed to delete department')
  }
}

const openPorterModal = () => {
  editingPorter.value = null
  showPorterModal.value = true
}

const closePorterModal = () => {
  showPorterModal.value = false
  editingPorter.value = null
  if (porterFormRef.value) {
    porterFormRef.value.resetForm()
  }
}

const editPorter = (porter) => {
  editingPorter.value = porter
  showPorterModal.value = true
}

const savePorterModal = () => {
  if (porterFormRef.value) {
    porterFormRef.value.handleSubmit()
  }
}

const handlePorterSubmit = async (formData) => {
  isSubmitting.value = true

  try {
    const url = editingPorter.value
      ? `http://localhost:3001/api/porters/${editingPorter.value.id}`
      : 'http://localhost:3001/api/porters'

    const method = editingPorter.value ? 'PUT' : 'POST'

    const response = await fetch(url, {
      method,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(formData)
    })

    if (response.ok) {
      await fetchPorters()
      closePorterModal()
    } else {
      const error = await response.json()
      alert(`Error: ${error.error || 'Failed to save porter'}`)
    }
  } catch (error) {
    console.error('Error saving porter:', error)
    alert('Failed to save porter')
  } finally {
    isSubmitting.value = false
  }
}

const deletePorter = async (porter) => {
  if (!confirm(`Are you sure you want to delete "${porter.name}"?`)) {
    return
  }

  try {
    const response = await fetch(`http://localhost:3001/api/porters/${porter.id}`, {
      method: 'DELETE'
    })

    if (response.ok) {
      await fetchPorters()
    } else {
      const error = await response.json()
      alert(`Error: ${error.error || 'Failed to delete porter'}`)
    }
  } catch (error) {
    console.error('Error deleting porter:', error)
    alert('Failed to delete porter')
  }
}

const openServiceModal = () => {
  editingService.value = null
  showServiceModal.value = true
}

const closeServiceModal = () => {
  showServiceModal.value = false
  editingService.value = null
  if (serviceFormRef.value) {
    serviceFormRef.value.resetForm()
  }
}

const editService = (service) => {
  editingService.value = service
  showServiceModal.value = true
}

const saveServiceModal = () => {
  if (serviceFormRef.value) {
    serviceFormRef.value.handleSubmit()
  }
}

const handleServiceSubmit = async (formData) => {
  isSubmitting.value = true

  try {
    const url = editingService.value
      ? `http://localhost:3001/api/services/${editingService.value.id}`
      : 'http://localhost:3001/api/services'

    const method = editingService.value ? 'PUT' : 'POST'

    const response = await fetch(url, {
      method,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(formData)
    })

    if (response.ok) {
      await fetchServices()
      closeServiceModal()
    } else {
      const error = await response.json()
      alert(`Error: ${error.error || 'Failed to save service'}`)
    }
  } catch (error) {
    console.error('Error saving service:', error)
    alert('Failed to save service')
  } finally {
    isSubmitting.value = false
  }
}

const deleteService = async (service) => {
  if (!confirm(`Are you sure you want to delete "${service.name}"?`)) {
    return
  }

  try {
    const response = await fetch(`http://localhost:3001/api/services/${service.id}`, {
      method: 'DELETE'
    })

    if (response.ok) {
      await fetchServices()
    } else {
      const error = await response.json()
      alert(`Error: ${error.error || 'Failed to delete service'}`)
    }
  } catch (error) {
    console.error('Error deleting service:', error)
    alert('Failed to delete service')
  }
}

const openShiftPatternModal = () => {
  editingShiftPattern.value = null
  showShiftPatternModal.value = true
}

const closeShiftPatternModal = () => {
  showShiftPatternModal.value = false
  editingShiftPattern.value = null
  if (shiftPatternFormRef.value) {
    shiftPatternFormRef.value.resetForm()
  }
}

const editShiftPattern = (pattern) => {
  editingShiftPattern.value = pattern
  showShiftPatternModal.value = true
}

const saveShiftPatternModal = () => {
  if (shiftPatternFormRef.value) {
    shiftPatternFormRef.value.handleSubmit()
  }
}

const handleShiftPatternSubmit = async (formData) => {
  isSubmitting.value = true

  try {
    const url = editingShiftPattern.value
      ? `http://localhost:3001/api/shift-patterns/${editingShiftPattern.value.id}`
      : 'http://localhost:3001/api/shift-patterns'

    const method = editingShiftPattern.value ? 'PUT' : 'POST'

    const response = await fetch(url, {
      method,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(formData)
    })

    if (response.ok) {
      await fetchShiftPatterns()
      closeShiftPatternModal()
    } else {
      const error = await response.json()
      alert(`Error: ${error.error || 'Failed to save shift pattern'}`)
    }
  } catch (error) {
    console.error('Error saving shift pattern:', error)
    alert('Failed to save shift pattern')
  } finally {
    isSubmitting.value = false
  }
}

const deleteShiftPattern = async (pattern) => {
  if (!confirm(`Are you sure you want to delete "${pattern.name}"?`)) {
    return
  }

  try {
    const response = await fetch(`http://localhost:3001/api/shift-patterns/${pattern.id}`, {
      method: 'DELETE'
    })

    if (response.ok) {
      await fetchShiftPatterns()
    } else {
      const error = await response.json()
      alert(`Error: ${error.error || 'Failed to delete shift pattern'}`)
    }
  } catch (error) {
    console.error('Error deleting shift pattern:', error)
    alert('Failed to delete shift pattern')
  }
}

const openCapabilityModal = () => {
  editingCapability.value = null
  showCapabilityModal.value = true
}

const closeCapabilityModal = () => {
  showCapabilityModal.value = false
  editingCapability.value = null
  if (capabilityFormRef.value) {
    capabilityFormRef.value.resetForm()
  }
}

const editCapability = (capability) => {
  editingCapability.value = capability
  showCapabilityModal.value = true
}

const saveCapabilityModal = () => {
  if (capabilityFormRef.value) {
    capabilityFormRef.value.handleSubmit()
  }
}

const handleCapabilitySubmit = async (formData) => {
  isSubmitting.value = true

  try {
    const url = editingCapability.value
      ? `http://localhost:3001/api/capabilities/${editingCapability.value.id}`
      : 'http://localhost:3001/api/capabilities'

    const method = editingCapability.value ? 'PUT' : 'POST'

    const response = await fetch(url, {
      method,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(formData)
    })

    if (response.ok) {
      await fetchCapabilities()
      closeCapabilityModal()
    } else {
      const error = await response.json()
      alert(`Error: ${error.error || 'Failed to save capability'}`)
    }
  } catch (error) {
    console.error('Error saving capability:', error)
    alert('Failed to save capability')
  } finally {
    isSubmitting.value = false
  }
}

const deleteCapability = async (capability) => {
  if (!confirm(`Are you sure you want to delete "${capability.name}"?`)) {
    return
  }

  try {
    const response = await fetch(`http://localhost:3001/api/capabilities/${capability.id}`, {
      method: 'DELETE'
    })

    if (response.ok) {
      await fetchCapabilities()
    } else {
      const error = await response.json()
      alert(`Error: ${error.error || 'Failed to delete capability'}`)
    }
  } catch (error) {
    console.error('Error deleting capability:', error)
    alert('Failed to delete capability')
  }
}

const openAllocationModal = () => {
  editingAllocation.value = null
  showAllocationModal.value = true
}

const closeAllocationModal = () => {
  showAllocationModal.value = false
  editingAllocation.value = null
  if (allocationFormRef.value) {
    allocationFormRef.value.resetForm()
  }
}

const editAllocation = (allocation) => {
  editingAllocation.value = allocation
  showAllocationModal.value = true
}

const saveAllocationModal = () => {
  if (allocationFormRef.value) {
    allocationFormRef.value.handleSubmit()
  }
}

const handleAllocationSubmit = async (formData) => {
  isSubmitting.value = true

  try {
    const url = editingAllocation.value
      ? `http://localhost:3001/api/allocations/${editingAllocation.value.id}`
      : 'http://localhost:3001/api/allocations'

    const method = editingAllocation.value ? 'PUT' : 'POST'

    const response = await fetch(url, {
      method,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(formData)
    })

    if (response.ok) {
      await fetchAllocations()
      closeAllocationModal()
    } else {
      const error = await response.json()
      alert(`Error: ${error.error || 'Failed to save allocation'}`)
    }
  } catch (error) {
    console.error('Error saving allocation:', error)
    alert('Failed to save allocation')
  } finally {
    isSubmitting.value = false
  }
}

const deleteAllocation = async (allocation) => {
  if (!confirm(`Are you sure you want to delete this allocation?`)) {
    return
  }

  try {
    const response = await fetch(`http://localhost:3001/api/allocations/${allocation.id}`, {
      method: 'DELETE'
    })

    if (response.ok) {
      await fetchAllocations()
    } else {
      const error = await response.json()
      alert(`Error: ${error.error || 'Failed to delete allocation'}`)
    }
  } catch (error) {
    console.error('Error deleting allocation:', error)
    alert('Failed to delete allocation')
  }
}

const openAvailabilityModal = () => {
  editingAvailability.value = null
  showAvailabilityModal.value = true
}

const closeAvailabilityModal = () => {
  showAvailabilityModal.value = false
  editingAvailability.value = null
  if (availabilityFormRef.value) {
    availabilityFormRef.value.resetForm()
  }
}

const editAvailability = (availability) => {
  editingAvailability.value = availability
  showAvailabilityModal.value = true
}

const saveAvailabilityModal = () => {
  if (availabilityFormRef.value) {
    availabilityFormRef.value.handleSubmit()
  }
}

const handleAvailabilitySubmit = async (formData) => {
  isSubmitting.value = true

  try {
    const url = editingAvailability.value
      ? `http://localhost:3001/api/availabilities/${editingAvailability.value.id}`
      : 'http://localhost:3001/api/availabilities'

    const method = editingAvailability.value ? 'PUT' : 'POST'

    const response = await fetch(url, {
      method,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(formData)
    })

    if (response.ok) {
      await fetchAvailabilities()
      closeAvailabilityModal()
    } else {
      const error = await response.json()
      alert(`Error: ${error.error || 'Failed to save availability'}`)
    }
  } catch (error) {
    console.error('Error saving availability:', error)
    alert('Failed to save availability')
  } finally {
    isSubmitting.value = false
  }
}

const deleteAvailability = async (availability) => {
  if (!confirm(`Are you sure you want to delete this availability record?`)) {
    return
  }

  try {
    const response = await fetch(`http://localhost:3001/api/availabilities/${availability.id}`, {
      method: 'DELETE'
    })

    if (response.ok) {
      await fetchAvailabilities()
    } else {
      const error = await response.json()
      alert(`Error: ${error.error || 'Failed to delete availability'}`)
    }
  } catch (error) {
    console.error('Error deleting availability:', error)
    alert('Failed to delete availability')
  }
}

const saveSettings = () => {
  if (settingsFormRef.value) {
    settingsFormRef.value.handleSubmit()
  }
}

const handleSettingsSubmit = async (formData) => {
  isSubmitting.value = true

  try {
    const response = await fetch('http://localhost:3001/api/settings', {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(formData)
    })

    if (response.ok) {
      await fetchSettings()
      alert('Settings saved successfully!')
    } else {
      const error = await response.json()
      alert(`Error: ${error.error || 'Failed to save settings'}`)
    }
  } catch (error) {
    console.error('Error saving settings:', error)
    alert('Failed to save settings')
  } finally {
    isSubmitting.value = false
  }
}

// Lifecycle
onMounted(() => {
  fetchBuildings()
  fetchDepartments()
  fetchPorters()
  fetchServices()
  fetchShiftPatterns()
  fetchCapabilities()
  fetchAllocations()
  fetchAvailabilities()
  fetchSettings()
})
</script>
