<template>
  <form @submit.prevent="handleSubmit" class="space-y-6">
    <!-- Basic Information -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="form-label">Porter *</label>
        <select
          v-model="formData.porter_id"
          class="form-select"
          :class="{ 'border-red-500': errors.porter_id }"
          required
        >
          <option value="">Select a porter</option>
          <option v-for="porter in porters" :key="porter.id" :value="porter.id">
            {{ porter.name }} ({{ porter.employee_id }})
          </option>
        </select>
        <p v-if="errors.porter_id" class="text-red-500 text-sm mt-1">{{ errors.porter_id }}</p>
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

    <!-- Date and Time -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div>
        <label class="form-label">Date *</label>
        <input
          v-model="formData.allocation_date"
          type="date"
          class="form-input"
          :class="{ 'border-red-500': errors.allocation_date }"
          required
        />
        <p v-if="errors.allocation_date" class="text-red-500 text-sm mt-1">{{ errors.allocation_date }}</p>
      </div>

      <div>
        <label class="form-label">Start Time *</label>
        <input
          v-model="formData.start_time"
          type="time"
          class="form-input"
          :class="{ 'border-red-500': errors.start_time }"
          required
        />
        <p v-if="errors.start_time" class="text-red-500 text-sm mt-1">{{ errors.start_time }}</p>
      </div>

      <div>
        <label class="form-label">End Time *</label>
        <input
          v-model="formData.end_time"
          type="time"
          class="form-input"
          :class="{ 'border-red-500': errors.end_time }"
          required
        />
        <p v-if="errors.end_time" class="text-red-500 text-sm mt-1">{{ errors.end_time }}</p>
      </div>
    </div>

    <!-- Allocation Details -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="form-label">Allocation Type</label>
        <select v-model="formData.allocation_type" class="form-select">
          <option value="REGULAR">Regular Shift</option>
          <option value="OVERTIME">Overtime</option>
          <option value="EMERGENCY">Emergency Cover</option>
          <option value="TEMPORARY">Temporary Assignment</option>
          <option value="TRAINING">Training</option>
          <option value="ON_CALL">On Call</option>
        </select>
      </div>

      <div>
        <label class="form-label">Priority Level</label>
        <select v-model="formData.priority" class="form-select">
          <option value="LOW">Low</option>
          <option value="MEDIUM">Medium</option>
          <option value="HIGH">High</option>
          <option value="URGENT">Urgent</option>
          <option value="EMERGENCY">Emergency</option>
        </select>
      </div>
    </div>

    <!-- Service Assignment -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="form-label">Assigned Service</label>
        <select v-model="formData.service_id" class="form-select">
          <option value="">No specific service</option>
          <option v-for="service in services" :key="service.id" :value="service.id">
            {{ service.name }}
          </option>
        </select>
      </div>

      <div>
        <label class="form-label">Shift Pattern</label>
        <select v-model="formData.shift_pattern_id" class="form-select">
          <option value="">No specific pattern</option>
          <option v-for="pattern in shiftPatterns" :key="pattern.id" :value="pattern.id">
            {{ pattern.name }}
          </option>
        </select>
      </div>
    </div>

    <!-- Location and Requirements -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="form-label">Location</label>
        <input
          v-model="formData.location"
          type="text"
          class="form-input"
          placeholder="e.g., Main Building, Ward 3"
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

    <!-- Break Times -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="form-label">Break Start Time</label>
        <input
          v-model="formData.break_start"
          type="time"
          class="form-input"
        />
      </div>

      <div>
        <label class="form-label">Break End Time</label>
        <input
          v-model="formData.break_end"
          type="time"
          class="form-input"
        />
      </div>
    </div>

    <!-- Status and Approval -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="form-label">Status</label>
        <select v-model="formData.status" class="form-select">
          <option value="PENDING">Pending</option>
          <option value="CONFIRMED">Confirmed</option>
          <option value="IN_PROGRESS">In Progress</option>
          <option value="COMPLETED">Completed</option>
          <option value="CANCELLED">Cancelled</option>
          <option value="NO_SHOW">No Show</option>
        </select>
      </div>

      <div>
        <label class="form-label">Approved By</label>
        <input
          v-model="formData.approved_by"
          type="text"
          class="form-input"
          placeholder="Manager or supervisor name"
        />
      </div>
    </div>

    <!-- Additional Information -->
    <div>
      <label class="form-label">Special Instructions</label>
      <textarea
        v-model="formData.special_instructions"
        class="form-input"
        rows="3"
        placeholder="Any special instructions or requirements for this allocation"
      ></textarea>
    </div>

    <!-- Notes -->
    <div>
      <label class="form-label">Notes</label>
      <textarea
        v-model="formData.notes"
        class="form-input"
        rows="2"
        placeholder="Additional notes or comments"
      ></textarea>
    </div>
  </form>
</template>

<script setup>
import { ref, watch } from 'vue'

const props = defineProps({
  allocation: {
    type: Object,
    default: null
  },
  porters: {
    type: Array,
    default: () => []
  },
  departments: {
    type: Array,
    default: () => []
  },
  services: {
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
  porter_id: '',
  department_id: '',
  allocation_date: new Date().toISOString().split('T')[0],
  start_time: '07:00',
  end_time: '15:00',
  allocation_type: 'REGULAR',
  priority: 'MEDIUM',
  service_id: '',
  shift_pattern_id: '',
  location: '',
  required_capabilities: '',
  break_start: '',
  break_end: '',
  status: 'PENDING',
  approved_by: '',
  special_instructions: '',
  notes: ''
})

// Validation errors
const errors = ref({})

// Watch for allocation prop changes (for editing)
watch(() => props.allocation, (newAllocation) => {
  if (newAllocation) {
    formData.value = {
      porter_id: newAllocation.porter_id || '',
      department_id: newAllocation.department_id || '',
      allocation_date: newAllocation.allocation_date || new Date().toISOString().split('T')[0],
      start_time: newAllocation.start_time || '07:00',
      end_time: newAllocation.end_time || '15:00',
      allocation_type: newAllocation.allocation_type || 'REGULAR',
      priority: newAllocation.priority || 'MEDIUM',
      service_id: newAllocation.service_id || '',
      shift_pattern_id: newAllocation.shift_pattern_id || '',
      location: newAllocation.location || '',
      required_capabilities: newAllocation.required_capabilities || '',
      break_start: newAllocation.break_start || '',
      break_end: newAllocation.break_end || '',
      status: newAllocation.status || 'PENDING',
      approved_by: newAllocation.approved_by || '',
      special_instructions: newAllocation.special_instructions || '',
      notes: newAllocation.notes || ''
    }
  } else {
    resetForm()
  }
}, { immediate: true })

// Methods
const resetForm = () => {
  formData.value = {
    porter_id: '',
    department_id: '',
    allocation_date: new Date().toISOString().split('T')[0],
    start_time: '07:00',
    end_time: '15:00',
    allocation_type: 'REGULAR',
    priority: 'MEDIUM',
    service_id: '',
    shift_pattern_id: '',
    location: '',
    required_capabilities: '',
    break_start: '',
    break_end: '',
    status: 'PENDING',
    approved_by: '',
    special_instructions: '',
    notes: ''
  }
  errors.value = {}
}

const validateForm = () => {
  errors.value = {}
  
  if (!formData.value.porter_id) {
    errors.value.porter_id = 'Porter selection is required'
  }
  
  if (!formData.value.department_id) {
    errors.value.department_id = 'Department selection is required'
  }
  
  if (!formData.value.allocation_date) {
    errors.value.allocation_date = 'Allocation date is required'
  }
  
  if (!formData.value.start_time) {
    errors.value.start_time = 'Start time is required'
  }
  
  if (!formData.value.end_time) {
    errors.value.end_time = 'End time is required'
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
