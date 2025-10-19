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
        <label class="form-label">Availability Type</label>
        <select v-model="formData.availability_type" class="form-select">
          <option value="AVAILABLE">Available</option>
          <option value="UNAVAILABLE">Unavailable</option>
          <option value="PREFERRED">Preferred</option>
          <option value="LIMITED">Limited Availability</option>
          <option value="ON_CALL">On Call</option>
        </select>
      </div>
    </div>

    <!-- Date Range -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="form-label">Start Date *</label>
        <input
          v-model="formData.start_date"
          type="date"
          class="form-input"
          :class="{ 'border-red-500': errors.start_date }"
          required
        />
        <p v-if="errors.start_date" class="text-red-500 text-sm mt-1">{{ errors.start_date }}</p>
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

    <!-- Time Range -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="form-label">Start Time</label>
        <input
          v-model="formData.start_time"
          type="time"
          class="form-input"
        />
      </div>

      <div>
        <label class="form-label">End Time</label>
        <input
          v-model="formData.end_time"
          type="time"
          class="form-input"
        />
      </div>
    </div>

    <!-- Days of Week -->
    <div>
      <label class="form-label">Days of Week</label>
      <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mt-2">
        <label v-for="day in daysOfWeek" :key="day.value" class="flex items-center">
          <input
            v-model="formData.days_of_week"
            :value="day.value"
            type="checkbox"
            class="form-checkbox"
          />
          <span class="ml-2 text-sm text-gray-700 dark:text-gray-300">{{ day.label }}</span>
        </label>
      </div>
    </div>

    <!-- Recurring Pattern -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="form-label">Recurring Pattern</label>
        <select v-model="formData.recurring_pattern" class="form-select">
          <option value="NONE">One-time</option>
          <option value="DAILY">Daily</option>
          <option value="WEEKLY">Weekly</option>
          <option value="MONTHLY">Monthly</option>
          <option value="CUSTOM">Custom</option>
        </select>
      </div>

      <div>
        <label class="form-label">Priority Level</label>
        <select v-model="formData.priority" class="form-select">
          <option value="LOW">Low</option>
          <option value="MEDIUM">Medium</option>
          <option value="HIGH">High</option>
          <option value="URGENT">Urgent</option>
        </select>
      </div>
    </div>

    <!-- Constraints and Preferences -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="form-label">Maximum Hours per Day</label>
        <input
          v-model.number="formData.max_hours_per_day"
          type="number"
          min="1"
          max="24"
          class="form-input"
          placeholder="e.g., 8"
        />
      </div>

      <div>
        <label class="form-label">Maximum Days per Week</label>
        <input
          v-model.number="formData.max_days_per_week"
          type="number"
          min="1"
          max="7"
          class="form-input"
          placeholder="e.g., 5"
        />
      </div>
    </div>

    <!-- Department Preferences -->
    <div>
      <label class="form-label">Preferred Departments</label>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mt-2">
        <label v-for="department in departments" :key="department.id" class="flex items-center">
          <input
            v-model="formData.preferred_departments"
            :value="department.id"
            type="checkbox"
            class="form-checkbox"
          />
          <span class="ml-2 text-sm text-gray-700 dark:text-gray-300">{{ department.name }}</span>
        </label>
      </div>
    </div>

    <!-- Reason and Notes -->
    <div>
      <label class="form-label">Reason for Unavailability</label>
      <select v-model="formData.unavailability_reason" class="form-select">
        <option value="">Not applicable</option>
        <option value="ANNUAL_LEAVE">Annual Leave</option>
        <option value="SICK_LEAVE">Sick Leave</option>
        <option value="TRAINING">Training</option>
        <option value="PERSONAL">Personal</option>
        <option value="MATERNITY_PATERNITY">Maternity/Paternity</option>
        <option value="STUDY_LEAVE">Study Leave</option>
        <option value="OTHER">Other</option>
      </select>
    </div>

    <!-- Additional Notes -->
    <div>
      <label class="form-label">Notes</label>
      <textarea
        v-model="formData.notes"
        class="form-input"
        rows="3"
        placeholder="Additional notes or special requirements"
      ></textarea>
    </div>

    <!-- Status -->
    <div>
      <label class="form-label">Status</label>
      <select v-model="formData.status" class="form-select">
        <option value="ACTIVE">Active</option>
        <option value="PENDING">Pending Approval</option>
        <option value="APPROVED">Approved</option>
        <option value="REJECTED">Rejected</option>
        <option value="CANCELLED">Cancelled</option>
      </select>
    </div>
  </form>
</template>

<script setup>
import { ref, watch } from 'vue'

const props = defineProps({
  availability: {
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
  }
})

const emit = defineEmits(['submit'])

// Days of week options
const daysOfWeek = [
  { value: 'MONDAY', label: 'Monday' },
  { value: 'TUESDAY', label: 'Tuesday' },
  { value: 'WEDNESDAY', label: 'Wednesday' },
  { value: 'THURSDAY', label: 'Thursday' },
  { value: 'FRIDAY', label: 'Friday' },
  { value: 'SATURDAY', label: 'Saturday' },
  { value: 'SUNDAY', label: 'Sunday' }
]

// Form data
const formData = ref({
  porter_id: '',
  availability_type: 'AVAILABLE',
  start_date: new Date().toISOString().split('T')[0],
  end_date: '',
  start_time: '',
  end_time: '',
  days_of_week: [],
  recurring_pattern: 'NONE',
  priority: 'MEDIUM',
  max_hours_per_day: 8,
  max_days_per_week: 5,
  preferred_departments: [],
  unavailability_reason: '',
  notes: '',
  status: 'ACTIVE'
})

// Validation errors
const errors = ref({})

// Watch for availability prop changes (for editing)
watch(() => props.availability, (newAvailability) => {
  if (newAvailability) {
    formData.value = {
      porter_id: newAvailability.porter_id || '',
      availability_type: newAvailability.availability_type || 'AVAILABLE',
      start_date: newAvailability.start_date || new Date().toISOString().split('T')[0],
      end_date: newAvailability.end_date || '',
      start_time: newAvailability.start_time || '',
      end_time: newAvailability.end_time || '',
      days_of_week: newAvailability.days_of_week || [],
      recurring_pattern: newAvailability.recurring_pattern || 'NONE',
      priority: newAvailability.priority || 'MEDIUM',
      max_hours_per_day: newAvailability.max_hours_per_day || 8,
      max_days_per_week: newAvailability.max_days_per_week || 5,
      preferred_departments: newAvailability.preferred_departments || [],
      unavailability_reason: newAvailability.unavailability_reason || '',
      notes: newAvailability.notes || '',
      status: newAvailability.status || 'ACTIVE'
    }
  } else {
    resetForm()
  }
}, { immediate: true })

// Methods
const resetForm = () => {
  formData.value = {
    porter_id: '',
    availability_type: 'AVAILABLE',
    start_date: new Date().toISOString().split('T')[0],
    end_date: '',
    start_time: '',
    end_time: '',
    days_of_week: [],
    recurring_pattern: 'NONE',
    priority: 'MEDIUM',
    max_hours_per_day: 8,
    max_days_per_week: 5,
    preferred_departments: [],
    unavailability_reason: '',
    notes: '',
    status: 'ACTIVE'
  }
  errors.value = {}
}

const validateForm = () => {
  errors.value = {}
  
  if (!formData.value.porter_id) {
    errors.value.porter_id = 'Porter selection is required'
  }
  
  if (!formData.value.start_date) {
    errors.value.start_date = 'Start date is required'
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
