<template>
  <form @submit.prevent="handleSubmit" class="availability-form">
    <div class="form-group">
      <label for="porter">Porter *</label>
      <select
        id="porter"
        v-model="formData.porter_id"
        class="form-control"
        required
      >
        <option value="">Select Porter</option>
        <option v-for="porter in porters" :key="porter.id" :value="porter.id">
          {{ porter.name }} ({{ porter.contractType }})
        </option>
      </select>
    </div>

    <div class="form-row">
      <div class="form-group">
        <label for="start_datetime">Start Date & Time *</label>
        <input
          id="start_datetime"
          v-model="formData.start_datetime"
          type="datetime-local"
          class="form-control"
          required
        />
      </div>

      <div class="form-group">
        <label for="end_datetime">End Date & Time *</label>
        <input
          id="end_datetime"
          v-model="formData.end_datetime"
          type="datetime-local"
          class="form-control"
          required
        />
      </div>
    </div>

    <div class="form-row">
      <div class="form-group">
        <label for="status">Status *</label>
        <select
          id="status"
          v-model="formData.status"
          class="form-control"
          required
        >
          <option value="">Select Status</option>
          <option value="AVAILABLE">Available</option>
          <option value="UNAVAILABLE">Unavailable</option>
          <option value="OVERTIME">Overtime</option>
        </select>
      </div>

      <div class="form-group" v-if="formData.status === 'UNAVAILABLE'">
        <label for="reason">Reason *</label>
        <select
          id="reason"
          v-model="formData.reason"
          class="form-control"
          required
        >
          <option value="">Select Reason</option>
          <option value="Sick Leave">Sick Leave</option>
          <option value="Annual Leave">Annual Leave</option>
          <option value="Training">Training</option>
          <option value="Personal Leave">Personal Leave</option>
          <option value="Maternity/Paternity Leave">Maternity/Paternity Leave</option>
          <option value="Compassionate Leave">Compassionate Leave</option>
          <option value="Study Leave">Study Leave</option>
          <option value="Other">Other</option>
        </select>
      </div>

      <div class="form-group" v-else>
        <label for="reason">Notes</label>
        <input
          id="reason"
          v-model="formData.reason"
          type="text"
          class="form-control"
          placeholder="Optional notes..."
        />
      </div>
    </div>

    <div class="form-group" v-if="formData.reason === 'Other'">
      <label for="custom_reason">Custom Reason *</label>
      <input
        id="custom_reason"
        v-model="formData.custom_reason"
        type="text"
        class="form-control"
        required
        placeholder="Please specify the reason..."
      />
    </div>

    <div class="status-info" v-if="formData.status">
      <div class="info-card" :class="getStatusClass(formData.status)">
        <h4>{{ getStatusTitle(formData.status) }}</h4>
        <p>{{ getStatusDescription(formData.status) }}</p>
      </div>
    </div>

    <div class="form-actions">
      <button type="button" @click="$emit('cancel')" class="btn btn-secondary">
        Cancel
      </button>
      <button type="submit" class="btn btn-primary" :disabled="saving">
        {{ saving ? 'Saving...' : (availability ? 'Update' : 'Create') }} Record
      </button>
    </div>
  </form>
</template>

<script setup>
import { ref, watch, onMounted, computed } from 'vue'

const props = defineProps({
  availability: {
    type: Object,
    default: null
  }
})

const emit = defineEmits(['submit', 'cancel'])

const formData = ref({
  porter_id: '',
  start_datetime: '',
  end_datetime: '',
  status: '',
  reason: '',
  custom_reason: ''
})

const saving = ref(false)
const porters = ref([])

// Watch for availability changes (edit mode)
watch(() => props.availability, (newAvailability) => {
  if (newAvailability) {
    formData.value = {
      porter_id: newAvailability.porterId || '',
      start_datetime: newAvailability.startDatetime ? new Date(newAvailability.startDatetime).toISOString().slice(0, 16) : '',
      end_datetime: newAvailability.endDatetime ? new Date(newAvailability.endDatetime).toISOString().slice(0, 16) : '',
      status: newAvailability.status || '',
      reason: newAvailability.reason || '',
      custom_reason: ''
    }
  } else {
    // Reset form for create mode
    const now = new Date()
    const tomorrow = new Date(now)
    tomorrow.setDate(tomorrow.getDate() + 1)
    
    formData.value = {
      porter_id: '',
      start_datetime: now.toISOString().slice(0, 16),
      end_datetime: tomorrow.toISOString().slice(0, 16),
      status: '',
      reason: '',
      custom_reason: ''
    }
  }
}, { immediate: true })

const fetchPorters = async () => {
  try {
    const response = await fetch('http://localhost:3001/api/porters')
    const result = await response.json()
    
    if (result.success) {
      porters.value = result.data
    }
  } catch (error) {
    console.error('Error fetching porters:', error)
  }
}

const getStatusClass = (status) => {
  switch (status) {
    case 'AVAILABLE': return 'status-available'
    case 'UNAVAILABLE': return 'status-unavailable'
    case 'OVERTIME': return 'status-overtime'
    default: return ''
  }
}

const getStatusTitle = (status) => {
  switch (status) {
    case 'AVAILABLE': return 'Available for Work'
    case 'UNAVAILABLE': return 'Unavailable'
    case 'OVERTIME': return 'Overtime Period'
    default: return ''
  }
}

const getStatusDescription = (status) => {
  switch (status) {
    case 'AVAILABLE': return 'Porter is available for additional assignments during this period.'
    case 'UNAVAILABLE': return 'Porter is not available for work during this period and will be excluded from coverage calculations.'
    case 'OVERTIME': return 'Porter is working overtime during this period.'
    default: return ''
  }
}

const handleSubmit = async () => {
  saving.value = true
  
  try {
    const submitData = { ...formData.value }
    
    // Use custom reason if "Other" is selected
    if (submitData.reason === 'Other' && submitData.custom_reason) {
      submitData.reason = submitData.custom_reason
    }
    
    // Remove custom_reason from submission
    delete submitData.custom_reason
    
    const url = props.availability 
      ? `http://localhost:3001/api/availability/${props.availability.id}`
      : 'http://localhost:3001/api/availability'
    
    const method = props.availability ? 'PUT' : 'POST'
    
    const response = await fetch(url, {
      method,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(submitData)
    })

    const result = await response.json()
    
    if (result.success) {
      emit('submit', result.data)
    } else {
      alert('Error: ' + result.error)
    }
  } catch (error) {
    console.error('Error saving availability:', error)
    alert('Failed to save availability record')
  } finally {
    saving.value = false
  }
}

onMounted(() => {
  fetchPorters()
})
</script>

<style scoped>
.availability-form {
  max-width: 600px;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
  margin-bottom: 1rem;
}

.form-group {
  margin-bottom: 1rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.25rem;
  font-weight: 600;
  color: #374151;
}

.form-control {
  width: 100%;
  padding: 0.5rem;
  border: 1px solid #d1d5db;
  border-radius: 4px;
  font-size: 0.875rem;
}

.form-control:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.status-info {
  margin: 1rem 0;
}

.info-card {
  padding: 1rem;
  border-radius: 6px;
  border-left: 4px solid;
}

.info-card h4 {
  margin: 0 0 0.5rem 0;
  font-size: 0.875rem;
  font-weight: 600;
}

.info-card p {
  margin: 0;
  font-size: 0.75rem;
  opacity: 0.8;
}

.status-available {
  background-color: #f0fdf4;
  border-left-color: #22c55e;
  color: #15803d;
}

.status-unavailable {
  background-color: #fef2f2;
  border-left-color: #ef4444;
  color: #dc2626;
}

.status-overtime {
  background-color: #fffbeb;
  border-left-color: #f59e0b;
  color: #d97706;
}

.form-actions {
  display: flex;
  gap: 0.5rem;
  justify-content: flex-end;
  margin-top: 1.5rem;
  padding-top: 1rem;
  border-top: 1px solid #e5e7eb;
}

.btn {
  padding: 0.5rem 1rem;
  border: none;
  border-radius: 4px;
  font-size: 0.875rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-secondary {
  background-color: #6b7280;
  color: white;
}

.btn-secondary:hover {
  background-color: #4b5563;
}

.btn-primary {
  background-color: #3b82f6;
  color: white;
}

.btn-primary:hover:not(:disabled) {
  background-color: #2563eb;
}

.btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

@media (max-width: 768px) {
  .form-row {
    grid-template-columns: 1fr;
  }
}
</style>
