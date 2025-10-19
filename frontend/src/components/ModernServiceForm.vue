<template>
  <form @submit.prevent="handleSubmit" class="space-y-6">
    <!-- Basic Information -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="form-label">Service Name *</label>
        <input
          v-model="formData.name"
          type="text"
          class="form-input"
          :class="{ 'border-red-500': errors.name }"
          placeholder="e.g., Patient Transport"
          required
        />
        <p v-if="errors.name" class="text-red-500 text-sm mt-1">{{ errors.name }}</p>
      </div>

      <div>
        <label class="form-label">Department *</label>
        <select
          v-model="formData.department_id"
          class="form-select"
          :class="{ 'border-red-500': errors.department_id }"
          required
        >
          <option value="">Select a department</option>
          <option v-for="department in departments" :key="department.id" :value="department.id">
            {{ department.name }}
          </option>
        </select>
        <p v-if="errors.department_id" class="text-red-500 text-sm mt-1">{{ errors.department_id }}</p>
      </div>
    </div>

    <!-- Description -->
    <div>
      <label class="form-label">Description</label>
      <textarea
        v-model="formData.description"
        class="form-input"
        rows="3"
        placeholder="Brief description of the service and its requirements"
      ></textarea>
    </div>

    <!-- Service Details -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div>
        <label class="form-label">Service Type</label>
        <select v-model="formData.service_type" class="form-select">
          <option value="PATIENT_TRANSPORT">Patient Transport</option>
          <option value="EQUIPMENT_DELIVERY">Equipment Delivery</option>
          <option value="SPECIMEN_COLLECTION">Specimen Collection</option>
          <option value="MAINTENANCE">Maintenance</option>
          <option value="CLEANING">Cleaning</option>
          <option value="SECURITY">Security</option>
          <option value="GENERAL">General</option>
        </select>
      </div>

      <div>
        <label class="form-label">Priority Level</label>
        <select v-model="formData.priority_level" class="form-select">
          <option value="LOW">Low</option>
          <option value="MEDIUM">Medium</option>
          <option value="HIGH">High</option>
          <option value="URGENT">Urgent</option>
          <option value="EMERGENCY">Emergency</option>
        </select>
      </div>

      <div>
        <label class="form-label">Estimated Duration (minutes)</label>
        <input
          v-model.number="formData.estimated_duration"
          type="number"
          min="1"
          class="form-input"
          placeholder="e.g., 15"
        />
      </div>
    </div>

    <!-- Requirements -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="form-label">Required Porters</label>
        <input
          v-model.number="formData.required_porters"
          type="number"
          min="1"
          class="form-input"
          placeholder="e.g., 2"
        />
      </div>

      <div>
        <label class="form-label">Required Capabilities</label>
        <input
          v-model="formData.required_capabilities"
          type="text"
          class="form-input"
          placeholder="e.g., Patient Handling, Equipment Operation"
        />
      </div>
    </div>

    <!-- Availability -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="form-label">Available Hours</label>
        <select v-model="formData.available_hours" class="form-select">
          <option value="24_7">24/7</option>
          <option value="BUSINESS_HOURS">Business Hours Only</option>
          <option value="EXTENDED_HOURS">Extended Hours</option>
          <option value="ON_CALL">On Call</option>
        </select>
      </div>

      <div>
        <label class="form-label">Location</label>
        <input
          v-model="formData.location"
          type="text"
          class="form-input"
          placeholder="e.g., Main Building, Floor 2"
        />
      </div>
    </div>

    <!-- Contact Information -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="form-label">Contact Person</label>
        <input
          v-model="formData.contact_person"
          type="text"
          class="form-input"
          placeholder="Service coordinator name"
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

    <!-- Status -->
    <div>
      <label class="form-label">Status</label>
      <select v-model="formData.status" class="form-select">
        <option value="ACTIVE">Active</option>
        <option value="INACTIVE">Inactive</option>
        <option value="SUSPENDED">Suspended</option>
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
        placeholder="Additional notes or special instructions"
      ></textarea>
    </div>
  </form>
</template>

<script setup>
import { ref, watch } from 'vue'

const props = defineProps({
  service: {
    type: Object,
    default: null
  },
  departments: {
    type: Array,
    default: () => []
  }
})

const emit = defineEmits(['submit'])

// Form data
const formData = ref({
  name: '',
  department_id: '',
  description: '',
  service_type: 'GENERAL',
  priority_level: 'MEDIUM',
  estimated_duration: 15,
  required_porters: 1,
  required_capabilities: '',
  available_hours: 'BUSINESS_HOURS',
  location: '',
  contact_person: '',
  contact_phone: '',
  status: 'ACTIVE',
  notes: ''
})

// Validation errors
const errors = ref({})

// Watch for service prop changes (for editing)
watch(() => props.service, (newService) => {
  if (newService) {
    formData.value = {
      name: newService.name || '',
      department_id: newService.department_id || '',
      description: newService.description || '',
      service_type: newService.service_type || 'GENERAL',
      priority_level: newService.priority_level || 'MEDIUM',
      estimated_duration: newService.estimated_duration || 15,
      required_porters: newService.required_porters || 1,
      required_capabilities: newService.required_capabilities || '',
      available_hours: newService.available_hours || 'BUSINESS_HOURS',
      location: newService.location || '',
      contact_person: newService.contact_person || '',
      contact_phone: newService.contact_phone || '',
      status: newService.status || 'ACTIVE',
      notes: newService.notes || ''
    }
  } else {
    resetForm()
  }
}, { immediate: true })

// Methods
const resetForm = () => {
  formData.value = {
    name: '',
    department_id: '',
    description: '',
    service_type: 'GENERAL',
    priority_level: 'MEDIUM',
    estimated_duration: 15,
    required_porters: 1,
    required_capabilities: '',
    available_hours: 'BUSINESS_HOURS',
    location: '',
    contact_person: '',
    contact_phone: '',
    status: 'ACTIVE',
    notes: ''
  }
  errors.value = {}
}

const validateForm = () => {
  errors.value = {}
  
  if (!formData.value.name.trim()) {
    errors.value.name = 'Service name is required'
  }
  
  if (!formData.value.department_id) {
    errors.value.department_id = 'Department selection is required'
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
