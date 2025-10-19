<template>
  <form @submit.prevent="handleSubmit" class="space-y-6">
    <!-- Basic Information -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="form-label">Porter Name *</label>
        <input
          v-model="formData.name"
          type="text"
          class="form-input"
          :class="{ 'border-red-500': errors.name }"
          placeholder="e.g., John Smith"
          required
        />
        <p v-if="errors.name" class="text-red-500 text-sm mt-1">{{ errors.name }}</p>
      </div>

      <div>
        <label class="form-label">Employee ID</label>
        <input
          v-model="formData.employee_id"
          type="text"
          class="form-input"
          placeholder="e.g., EMP001"
        />
      </div>
    </div>

    <!-- Contact Information -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="form-label">Email</label>
        <input
          v-model="formData.email"
          type="email"
          class="form-input"
          placeholder="e.g., john.smith@hospital.com"
        />
      </div>

      <div>
        <label class="form-label">Phone</label>
        <input
          v-model="formData.phone"
          type="tel"
          class="form-input"
          placeholder="e.g., +44 20 1234 5678"
        />
      </div>
    </div>

    <!-- Employment Details -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div>
        <label class="form-label">Contract Type *</label>
        <select
          v-model="formData.contract_type"
          class="form-select"
          :class="{ 'border-red-500': errors.contract_type }"
          required
        >
          <option value="">Select contract type</option>
          <option value="FULL_TIME">Full Time</option>
          <option value="PART_TIME">Part Time</option>
          <option value="TEMPORARY">Temporary</option>
          <option value="AGENCY">Agency</option>
        </select>
        <p v-if="errors.contract_type" class="text-red-500 text-sm mt-1">{{ errors.contract_type }}</p>
      </div>

      <div>
        <label class="form-label">Porter Type *</label>
        <select
          v-model="formData.porter_type"
          class="form-select"
          :class="{ 'border-red-500': errors.porter_type }"
          required
        >
          <option value="">Select porter type</option>
          <option value="GENERAL">General Porter</option>
          <option value="PATIENT_TRANSPORT">Patient Transport</option>
          <option value="THEATRE">Theatre Porter</option>
          <option value="MORTUARY">Mortuary Porter</option>
          <option value="MAINTENANCE">Maintenance Porter</option>
        </select>
        <p v-if="errors.porter_type" class="text-red-500 text-sm mt-1">{{ errors.porter_type }}</p>
      </div>

      <div>
        <label class="form-label">Regular Department</label>
        <select
          v-model="formData.regular_department_id"
          class="form-select"
        >
          <option value="">No regular department</option>
          <option v-for="department in departments" :key="department.id" :value="department.id">
            {{ department.name }}
          </option>
        </select>
      </div>
    </div>

    <!-- Dates -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="form-label">Start Date</label>
        <input
          v-model="formData.start_date"
          type="date"
          class="form-input"
        />
      </div>

      <div>
        <label class="form-label">End Date</label>
        <input
          v-model="formData.end_date"
          type="date"
          class="form-input"
        />
      </div>
    </div>

    <!-- Shift Pattern -->
    <div>
      <label class="form-label">Shift Pattern</label>
      <select
        v-model="formData.shift_pattern_id"
        class="form-select"
      >
        <option value="">No assigned shift pattern</option>
        <option v-for="pattern in shiftPatterns" :key="pattern.id" :value="pattern.id">
          {{ pattern.name }}
        </option>
      </select>
    </div>

    <!-- Status -->
    <div>
      <label class="form-label">Status</label>
      <select v-model="formData.status" class="form-select">
        <option value="ACTIVE">Active</option>
        <option value="INACTIVE">Inactive</option>
        <option value="ON_LEAVE">On Leave</option>
        <option value="SUSPENDED">Suspended</option>
      </select>
    </div>

    <!-- Notes -->
    <div>
      <label class="form-label">Notes</label>
      <textarea
        v-model="formData.notes"
        class="form-input"
        rows="3"
        placeholder="Additional notes about the porter"
      ></textarea>
    </div>
  </form>
</template>

<script setup>
import { ref, watch, onMounted } from 'vue'

const props = defineProps({
  porter: {
    type: Object,
    default: null
  },
  departments: {
    type: Array,
    default: () => []
  },
  shiftPatterns: {
    type: Array,
    default: () => []
  }
})

const emit = defineEmits(['submit'])

// Form data
const formData = ref({
  name: '',
  employee_id: '',
  email: '',
  phone: '',
  contract_type: '',
  porter_type: '',
  regular_department_id: '',
  shift_pattern_id: '',
  start_date: '',
  end_date: '',
  status: 'ACTIVE',
  notes: ''
})

// Validation errors
const errors = ref({})

// Watch for porter prop changes (for editing)
watch(() => props.porter, (newPorter) => {
  if (newPorter) {
    formData.value = {
      name: newPorter.name || '',
      employee_id: newPorter.employee_id || '',
      email: newPorter.email || '',
      phone: newPorter.phone || '',
      contract_type: newPorter.contract_type || '',
      porter_type: newPorter.porter_type || '',
      regular_department_id: newPorter.regular_department_id || '',
      shift_pattern_id: newPorter.shift_pattern_id || '',
      start_date: newPorter.start_date ? newPorter.start_date.split('T')[0] : '',
      end_date: newPorter.end_date ? newPorter.end_date.split('T')[0] : '',
      status: newPorter.status || 'ACTIVE',
      notes: newPorter.notes || ''
    }
  } else {
    resetForm()
  }
}, { immediate: true })

// Methods
const resetForm = () => {
  formData.value = {
    name: '',
    employee_id: '',
    email: '',
    phone: '',
    contract_type: '',
    porter_type: '',
    regular_department_id: '',
    shift_pattern_id: '',
    start_date: '',
    end_date: '',
    status: 'ACTIVE',
    notes: ''
  }
  errors.value = {}
}

const validateForm = () => {
  errors.value = {}
  
  if (!formData.value.name.trim()) {
    errors.value.name = 'Porter name is required'
  }
  
  if (!formData.value.contract_type) {
    errors.value.contract_type = 'Contract type is required'
  }
  
  if (!formData.value.porter_type) {
    errors.value.porter_type = 'Porter type is required'
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
