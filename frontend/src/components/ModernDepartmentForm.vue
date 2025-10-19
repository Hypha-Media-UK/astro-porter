<template>
  <form @submit.prevent="handleSubmit" class="space-y-6">
    <!-- Basic Information -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="form-label">Department Name *</label>
        <input
          v-model="formData.name"
          type="text"
          class="form-input"
          :class="{ 'border-red-500': errors.name }"
          placeholder="e.g., Emergency Department"
          required
        />
        <p v-if="errors.name" class="text-red-500 text-sm mt-1">{{ errors.name }}</p>
      </div>

      <div>
        <label class="form-label">Building *</label>
        <select
          v-model="formData.building_id"
          class="form-select"
          :class="{ 'border-red-500': errors.building_id }"
          required
        >
          <option value="">Select a building</option>
          <option v-for="building in buildings" :key="building.id" :value="building.id">
            {{ building.name }}
          </option>
        </select>
        <p v-if="errors.building_id" class="text-red-500 text-sm mt-1">{{ errors.building_id }}</p>
      </div>
    </div>

    <!-- Description -->
    <div>
      <label class="form-label">Description</label>
      <textarea
        v-model="formData.description"
        class="form-input"
        rows="3"
        placeholder="Brief description of the department's function and responsibilities"
      ></textarea>
    </div>

    <!-- Staffing Requirements -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div>
        <label class="form-label">Required Porters (Day Shift)</label>
        <input
          v-model.number="formData.required_porters_day"
          type="number"
          min="0"
          class="form-input"
          placeholder="0"
        />
      </div>

      <div>
        <label class="form-label">Required Porters (Evening Shift)</label>
        <input
          v-model.number="formData.required_porters_evening"
          type="number"
          min="0"
          class="form-input"
          placeholder="0"
        />
      </div>

      <div>
        <label class="form-label">Required Porters (Night Shift)</label>
        <input
          v-model.number="formData.required_porters_night"
          type="number"
          min="0"
          class="form-input"
          placeholder="0"
        />
      </div>
    </div>

    <!-- Contact Information -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="form-label">Manager Name</label>
        <input
          v-model="formData.manager_name"
          type="text"
          class="form-input"
          placeholder="Department manager name"
        />
      </div>

      <div>
        <label class="form-label">Contact Phone</label>
        <input
          v-model="formData.contact_phone"
          type="tel"
          class="form-input"
          placeholder="e.g., +44 20 1234 5678"
        />
      </div>
    </div>

    <!-- Location -->
    <div>
      <label class="form-label">Location/Floor</label>
      <input
        v-model="formData.location"
        type="text"
        class="form-input"
        placeholder="e.g., Ground Floor, Wing A"
      />
    </div>

    <!-- Status -->
    <div>
      <label class="form-label">Status</label>
      <select v-model="formData.status" class="form-select">
        <option value="ACTIVE">Active</option>
        <option value="INACTIVE">Inactive</option>
        <option value="MAINTENANCE">Under Maintenance</option>
      </select>
    </div>

    <!-- Notes -->
    <div>
      <label class="form-label">Notes</label>
      <textarea
        v-model="formData.notes"
        class="form-input"
        rows="3"
        placeholder="Additional notes or special requirements"
      ></textarea>
    </div>
  </form>
</template>

<script setup>
import { ref, watch, onMounted } from 'vue'

const props = defineProps({
  department: {
    type: Object,
    default: null
  },
  buildings: {
    type: Array,
    default: () => []
  }
})

const emit = defineEmits(['submit'])

// Form data
const formData = ref({
  name: '',
  building_id: '',
  description: '',
  required_porters_day: 0,
  required_porters_evening: 0,
  required_porters_night: 0,
  manager_name: '',
  contact_phone: '',
  location: '',
  status: 'ACTIVE',
  notes: ''
})

// Validation errors
const errors = ref({})

// Watch for department prop changes (for editing)
watch(() => props.department, (newDepartment) => {
  if (newDepartment) {
    formData.value = {
      name: newDepartment.name || '',
      building_id: newDepartment.building_id || '',
      description: newDepartment.description || '',
      required_porters_day: newDepartment.required_porters_day || 0,
      required_porters_evening: newDepartment.required_porters_evening || 0,
      required_porters_night: newDepartment.required_porters_night || 0,
      manager_name: newDepartment.manager_name || '',
      contact_phone: newDepartment.contact_phone || '',
      location: newDepartment.location || '',
      status: newDepartment.status || 'ACTIVE',
      notes: newDepartment.notes || ''
    }
  } else {
    resetForm()
  }
}, { immediate: true })

// Methods
const resetForm = () => {
  formData.value = {
    name: '',
    building_id: '',
    description: '',
    required_porters_day: 0,
    required_porters_evening: 0,
    required_porters_night: 0,
    manager_name: '',
    contact_phone: '',
    location: '',
    status: 'ACTIVE',
    notes: ''
  }
  errors.value = {}
}

const validateForm = () => {
  errors.value = {}
  
  if (!formData.value.name.trim()) {
    errors.value.name = 'Department name is required'
  }
  
  if (!formData.value.building_id) {
    errors.value.building_id = 'Building selection is required'
  }
  
  return Object.keys(errors.value).length === 0
}

const handleSubmit = () => {
  if (validateForm()) {
    emit('submit', formData.value)
  }
}

// Expose methods for parent component
defineExpose({
  resetForm,
  validateForm
})
</script>
