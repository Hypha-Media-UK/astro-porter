<template>
  <form @submit.prevent="handleSubmit" class="space-y-6">
    <!-- Basic Information -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="form-label">Pattern Name *</label>
        <input
          v-model="formData.name"
          type="text"
          class="form-input"
          :class="{ 'border-red-500': errors.name }"
          placeholder="e.g., Day Shift, Night Shift"
          required
        />
        <p v-if="errors.name" class="text-red-500 text-sm mt-1">{{ errors.name }}</p>
      </div>

      <div>
        <label class="form-label">Shift Type</label>
        <select v-model="formData.shift_type" class="form-select">
          <option value="DAY">Day Shift</option>
          <option value="EVENING">Evening Shift</option>
          <option value="NIGHT">Night Shift</option>
          <option value="ROTATING">Rotating</option>
          <option value="ON_CALL">On Call</option>
          <option value="SPLIT">Split Shift</option>
        </select>
      </div>
    </div>

    <!-- Time Configuration -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
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

    <!-- Duration and Break Information -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div>
        <label class="form-label">Duration (hours)</label>
        <input
          v-model.number="formData.duration_hours"
          type="number"
          min="1"
          max="24"
          step="0.5"
          class="form-input"
          placeholder="e.g., 8"
        />
      </div>

      <div>
        <label class="form-label">Break Duration (minutes)</label>
        <input
          v-model.number="formData.break_duration"
          type="number"
          min="0"
          class="form-input"
          placeholder="e.g., 30"
        />
      </div>

      <div>
        <label class="form-label">Meal Break (minutes)</label>
        <input
          v-model.number="formData.meal_break"
          type="number"
          min="0"
          class="form-input"
          placeholder="e.g., 60"
        />
      </div>
    </div>

    <!-- Working Days -->
    <div>
      <label class="form-label">Working Days</label>
      <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mt-2">
        <label v-for="day in daysOfWeek" :key="day.value" class="flex items-center">
          <input
            v-model="formData.working_days"
            :value="day.value"
            type="checkbox"
            class="form-checkbox"
          />
          <span class="ml-2 text-sm text-gray-700 dark:text-gray-300">{{ day.label }}</span>
        </label>
      </div>
    </div>

    <!-- Overtime and Rates -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="form-label">Overtime Rate Multiplier</label>
        <input
          v-model.number="formData.overtime_rate"
          type="number"
          min="1"
          step="0.1"
          class="form-input"
          placeholder="e.g., 1.5"
        />
      </div>

      <div>
        <label class="form-label">Night Shift Allowance</label>
        <input
          v-model.number="formData.night_allowance"
          type="number"
          min="0"
          step="0.01"
          class="form-input"
          placeholder="e.g., 15.00"
        />
      </div>
    </div>

    <!-- Minimum Staffing -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div>
        <label class="form-label">Minimum Porters Required</label>
        <input
          v-model.number="formData.min_porters"
          type="number"
          min="1"
          class="form-input"
          placeholder="e.g., 2"
        />
      </div>

      <div>
        <label class="form-label">Maximum Porters</label>
        <input
          v-model.number="formData.max_porters"
          type="number"
          min="1"
          class="form-input"
          placeholder="e.g., 5"
        />
      </div>

      <div>
        <label class="form-label">Priority Level</label>
        <select v-model="formData.priority" class="form-select">
          <option value="LOW">Low</option>
          <option value="MEDIUM">Medium</option>
          <option value="HIGH">High</option>
          <option value="CRITICAL">Critical</option>
        </select>
      </div>
    </div>

    <!-- Additional Configuration -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="form-label">Color Code</label>
        <input
          v-model="formData.color_code"
          type="color"
          class="form-input h-10"
        />
      </div>

      <div>
        <label class="form-label">Status</label>
        <select v-model="formData.status" class="form-select">
          <option value="ACTIVE">Active</option>
          <option value="INACTIVE">Inactive</option>
          <option value="DRAFT">Draft</option>
          <option value="ARCHIVED">Archived</option>
        </select>
      </div>
    </div>

    <!-- Description -->
    <div>
      <label class="form-label">Description</label>
      <textarea
        v-model="formData.description"
        class="form-input"
        rows="3"
        placeholder="Brief description of this shift pattern and its purpose"
      ></textarea>
    </div>

    <!-- Special Requirements -->
    <div>
      <label class="form-label">Special Requirements</label>
      <textarea
        v-model="formData.special_requirements"
        class="form-input"
        rows="2"
        placeholder="Any special requirements or notes for this shift pattern"
      ></textarea>
    </div>
  </form>
</template>

<script setup>
import { ref, watch } from 'vue'

const props = defineProps({
  shiftPattern: {
    type: Object,
    default: null
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
  name: '',
  shift_type: 'DAY',
  start_time: '07:00',
  end_time: '15:00',
  duration_hours: 8,
  break_duration: 15,
  meal_break: 30,
  working_days: ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY'],
  overtime_rate: 1.5,
  night_allowance: 0,
  min_porters: 1,
  max_porters: 5,
  priority: 'MEDIUM',
  color_code: '#3B82F6',
  status: 'ACTIVE',
  description: '',
  special_requirements: ''
})

// Validation errors
const errors = ref({})

// Watch for shiftPattern prop changes (for editing)
watch(() => props.shiftPattern, (newShiftPattern) => {
  if (newShiftPattern) {
    formData.value = {
      name: newShiftPattern.name || '',
      shift_type: newShiftPattern.shift_type || 'DAY',
      start_time: newShiftPattern.start_time || '07:00',
      end_time: newShiftPattern.end_time || '15:00',
      duration_hours: newShiftPattern.duration_hours || 8,
      break_duration: newShiftPattern.break_duration || 15,
      meal_break: newShiftPattern.meal_break || 30,
      working_days: newShiftPattern.working_days || ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY'],
      overtime_rate: newShiftPattern.overtime_rate || 1.5,
      night_allowance: newShiftPattern.night_allowance || 0,
      min_porters: newShiftPattern.min_porters || 1,
      max_porters: newShiftPattern.max_porters || 5,
      priority: newShiftPattern.priority || 'MEDIUM',
      color_code: newShiftPattern.color_code || '#3B82F6',
      status: newShiftPattern.status || 'ACTIVE',
      description: newShiftPattern.description || '',
      special_requirements: newShiftPattern.special_requirements || ''
    }
  } else {
    resetForm()
  }
}, { immediate: true })

// Methods
const resetForm = () => {
  formData.value = {
    name: '',
    shift_type: 'DAY',
    start_time: '07:00',
    end_time: '15:00',
    duration_hours: 8,
    break_duration: 15,
    meal_break: 30,
    working_days: ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY'],
    overtime_rate: 1.5,
    night_allowance: 0,
    min_porters: 1,
    max_porters: 5,
    priority: 'MEDIUM',
    color_code: '#3B82F6',
    status: 'ACTIVE',
    description: '',
    special_requirements: ''
  }
  errors.value = {}
}

const validateForm = () => {
  errors.value = {}
  
  if (!formData.value.name.trim()) {
    errors.value.name = 'Pattern name is required'
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
