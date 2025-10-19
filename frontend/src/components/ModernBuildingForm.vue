<template>
  <form @submit.prevent="handleSubmit" class="space-y-6">
    <!-- Building Name -->
    <div>
      <label for="name" class="form-label">
        Building Name <span class="text-red-500">*</span>
      </label>
      <input
        id="name"
        v-model="form.name"
        type="text"
        class="form-input"
        :class="{ 'border-red-500 focus:border-red-500 focus:ring-red-500': errors.name }"
        placeholder="Enter building name"
        required
      />
      <p v-if="errors.name" class="mt-1 text-sm text-red-600 dark:text-red-400">
        {{ errors.name }}
      </p>
    </div>

    <!-- Address -->
    <div>
      <label for="address" class="form-label">
        Address
      </label>
      <textarea
        id="address"
        v-model="form.address"
        rows="3"
        class="form-input"
        :class="{ 'border-red-500 focus:border-red-500 focus:ring-red-500': errors.address }"
        placeholder="Enter building address"
      ></textarea>
      <p v-if="errors.address" class="mt-1 text-sm text-red-600 dark:text-red-400">
        {{ errors.address }}
      </p>
    </div>

    <!-- Contact Information -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <!-- Contact Name -->
      <div>
        <label for="contact_name" class="form-label">
          Contact Name
        </label>
        <input
          id="contact_name"
          v-model="form.contact_name"
          type="text"
          class="form-input"
          :class="{ 'border-red-500 focus:border-red-500 focus:ring-red-500': errors.contact_name }"
          placeholder="Primary contact name"
        />
        <p v-if="errors.contact_name" class="mt-1 text-sm text-red-600 dark:text-red-400">
          {{ errors.contact_name }}
        </p>
      </div>

      <!-- Contact Phone -->
      <div>
        <label for="contact_phone" class="form-label">
          Contact Phone
        </label>
        <input
          id="contact_phone"
          v-model="form.contact_phone"
          type="tel"
          class="form-input"
          :class="{ 'border-red-500 focus:border-red-500 focus:ring-red-500': errors.contact_phone }"
          placeholder="Phone number"
        />
        <p v-if="errors.contact_phone" class="mt-1 text-sm text-red-600 dark:text-red-400">
          {{ errors.contact_phone }}
        </p>
      </div>
    </div>

    <!-- Operating Hours -->
    <div>
      <label class="form-label">Operating Hours</label>
      <div class="space-y-3">
        <!-- 24/7 Toggle -->
        <div class="flex items-center">
          <input
            id="is_24_7"
            v-model="form.is_24_7"
            type="checkbox"
            class="w-4 h-4 text-primary-600 bg-gray-100 border-gray-300 rounded focus:ring-primary-500 dark:focus:ring-primary-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600"
          />
          <label for="is_24_7" class="ml-2 text-sm font-medium text-gray-900 dark:text-gray-300">
            24/7 Operations
          </label>
        </div>

        <!-- Operating Hours (when not 24/7) -->
        <div v-if="!form.is_24_7" class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label for="operating_hours_start" class="form-label">
              Start Time
            </label>
            <input
              id="operating_hours_start"
              v-model="form.operating_hours_start"
              type="time"
              class="form-input"
              :class="{ 'border-red-500 focus:border-red-500 focus:ring-red-500': errors.operating_hours_start }"
            />
            <p v-if="errors.operating_hours_start" class="mt-1 text-sm text-red-600 dark:text-red-400">
              {{ errors.operating_hours_start }}
            </p>
          </div>

          <div>
            <label for="operating_hours_end" class="form-label">
              End Time
            </label>
            <input
              id="operating_hours_end"
              v-model="form.operating_hours_end"
              type="time"
              class="form-input"
              :class="{ 'border-red-500 focus:border-red-500 focus:ring-red-500': errors.operating_hours_end }"
            />
            <p v-if="errors.operating_hours_end" class="mt-1 text-sm text-red-600 dark:text-red-400">
              {{ errors.operating_hours_end }}
            </p>
          </div>
        </div>
      </div>
    </div>

    <!-- Status -->
    <div>
      <label for="status" class="form-label">
        Status <span class="text-red-500">*</span>
      </label>
      <select
        id="status"
        v-model="form.status"
        class="form-select"
        :class="{ 'border-red-500 focus:border-red-500 focus:ring-red-500': errors.status }"
        required
      >
        <option value="">Select status</option>
        <option value="ACTIVE">Active</option>
        <option value="INACTIVE">Inactive</option>
        <option value="MAINTENANCE">Under Maintenance</option>
      </select>
      <p v-if="errors.status" class="mt-1 text-sm text-red-600 dark:text-red-400">
        {{ errors.status }}
      </p>
    </div>

    <!-- Notes -->
    <div>
      <label for="notes" class="form-label">
        Notes
      </label>
      <textarea
        id="notes"
        v-model="form.notes"
        rows="3"
        class="form-input"
        :class="{ 'border-red-500 focus:border-red-500 focus:ring-red-500': errors.notes }"
        placeholder="Additional notes about this building"
      ></textarea>
      <p v-if="errors.notes" class="mt-1 text-sm text-red-600 dark:text-red-400">
        {{ errors.notes }}
      </p>
    </div>

    <!-- Form Actions -->
    <div class="flex items-center justify-end space-x-3 pt-4 border-t border-gray-200 dark:border-gray-600">
      <button
        type="button"
        class="btn-secondary"
        @click="$emit('cancel')"
      >
        Cancel
      </button>
      <button
        type="submit"
        class="btn-primary"
        :disabled="isSubmitting"
      >
        <i v-if="isSubmitting" class="fas fa-spinner fa-spin mr-2"></i>
        {{ isEditing ? 'Update Building' : 'Create Building' }}
      </button>
    </div>
  </form>
</template>

<script setup>
import { ref, computed, watch } from 'vue'

// Props
const props = defineProps({
  building: {
    type: Object,
    default: null
  },
  isSubmitting: {
    type: Boolean,
    default: false
  }
})

// Emits
const emit = defineEmits(['submit', 'cancel'])

// Reactive data
const form = ref({
  name: '',
  address: '',
  contact_name: '',
  contact_phone: '',
  is_24_7: false,
  operating_hours_start: '08:00',
  operating_hours_end: '18:00',
  status: 'ACTIVE',
  notes: ''
})

const errors = ref({})

// Computed
const isEditing = computed(() => !!props.building?.id)

// Methods
const validateForm = () => {
  errors.value = {}
  
  if (!form.value.name?.trim()) {
    errors.value.name = 'Building name is required'
  }
  
  if (!form.value.status) {
    errors.value.status = 'Status is required'
  }
  
  if (!form.value.is_24_7) {
    if (!form.value.operating_hours_start) {
      errors.value.operating_hours_start = 'Start time is required when not 24/7'
    }
    if (!form.value.operating_hours_end) {
      errors.value.operating_hours_end = 'End time is required when not 24/7'
    }
    if (form.value.operating_hours_start && form.value.operating_hours_end) {
      if (form.value.operating_hours_start >= form.value.operating_hours_end) {
        errors.value.operating_hours_end = 'End time must be after start time'
      }
    }
  }
  
  return Object.keys(errors.value).length === 0
}

const handleSubmit = () => {
  if (validateForm()) {
    const formData = { ...form.value }
    
    // Clean up operating hours if 24/7
    if (formData.is_24_7) {
      formData.operating_hours_start = null
      formData.operating_hours_end = null
    }
    
    emit('submit', formData)
  }
}

const resetForm = () => {
  form.value = {
    name: '',
    address: '',
    contact_name: '',
    contact_phone: '',
    is_24_7: false,
    operating_hours_start: '08:00',
    operating_hours_end: '18:00',
    status: 'ACTIVE',
    notes: ''
  }
  errors.value = {}
}

// Watch for building prop changes
watch(() => props.building, (newBuilding) => {
  if (newBuilding) {
    form.value = {
      name: newBuilding.name || '',
      address: newBuilding.address || '',
      contact_name: newBuilding.contact_name || '',
      contact_phone: newBuilding.contact_phone || '',
      is_24_7: newBuilding.is_24_7 || false,
      operating_hours_start: newBuilding.operating_hours_start || '08:00',
      operating_hours_end: newBuilding.operating_hours_end || '18:00',
      status: newBuilding.status || 'ACTIVE',
      notes: newBuilding.notes || ''
    }
  } else {
    resetForm()
  }
  errors.value = {}
}, { immediate: true })

// Expose methods for parent component
defineExpose({
  resetForm,
  validateForm
})
</script>
