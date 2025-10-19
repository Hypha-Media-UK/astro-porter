<template>
  <form @submit.prevent="handleSubmit" class="allocation-form">
    <div class="form-row">
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

      <div class="form-group">
        <label for="type">Allocation Type *</label>
        <select
          id="type"
          v-model="formData.type"
          class="form-control"
          required
        >
          <option value="">Select Type</option>
          <option value="REGULAR">Regular</option>
          <option value="TEMPORARY">Temporary</option>
          <option value="RELIEF">Relief</option>
        </select>
      </div>
    </div>

    <div class="form-row">
      <div class="form-group">
        <label for="department">Department *</label>
        <select
          id="department"
          v-model="formData.department_id"
          class="form-control"
          required
          @change="onDepartmentChange"
        >
          <option value="">Select Department</option>
          <option v-for="dept in departments" :key="dept.id" :value="dept.id">
            {{ dept.name }} ({{ dept.building?.name }})
          </option>
        </select>
      </div>

      <div class="form-group">
        <label for="service">Service (Optional)</label>
        <select
          id="service"
          v-model="formData.service_id"
          class="form-control"
        >
          <option value="">No specific service</option>
          <option v-for="service in availableServices" :key="service.id" :value="service.id">
            {{ service.name }}
          </option>
        </select>
      </div>
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
        <label for="end_datetime">End Date & Time</label>
        <input
          id="end_datetime"
          v-model="formData.end_datetime"
          type="datetime-local"
          class="form-control"
        />
        <small class="form-text">Leave empty for ongoing allocation</small>
      </div>
    </div>

    <div class="form-group">
      <label for="reason">Reason/Notes</label>
      <textarea
        id="reason"
        v-model="formData.reason"
        class="form-control"
        rows="2"
        placeholder="Optional reason for this allocation..."
      ></textarea>
    </div>

    <div class="form-actions">
      <button type="button" @click="$emit('cancel')" class="btn btn-secondary">
        Cancel
      </button>
      <button type="submit" class="btn btn-primary" :disabled="saving">
        {{ saving ? 'Saving...' : (allocation ? 'Update' : 'Create') }} Allocation
      </button>
    </div>
  </form>
</template>

<script setup>
import { ref, watch, onMounted, computed } from 'vue'

const props = defineProps({
  allocation: {
    type: Object,
    default: null
  }
})

const emit = defineEmits(['submit', 'cancel'])

const formData = ref({
  porter_id: '',
  department_id: '',
  service_id: '',
  start_datetime: '',
  end_datetime: '',
  type: '',
  reason: ''
})

const saving = ref(false)
const porters = ref([])
const departments = ref([])
const services = ref([])

const availableServices = computed(() => {
  if (!formData.value.department_id) return []
  return services.value.filter(service => service.departmentId === formData.value.department_id)
})

// Watch for allocation changes (edit mode)
watch(() => props.allocation, (newAllocation) => {
  if (newAllocation) {
    formData.value = {
      porter_id: newAllocation.porterId || '',
      department_id: newAllocation.departmentId || '',
      service_id: newAllocation.serviceId || '',
      start_datetime: newAllocation.startDatetime ? new Date(newAllocation.startDatetime).toISOString().slice(0, 16) : '',
      end_datetime: newAllocation.endDatetime ? new Date(newAllocation.endDatetime).toISOString().slice(0, 16) : '',
      type: newAllocation.type || '',
      reason: newAllocation.reason || ''
    }
  } else {
    // Reset form for create mode
    formData.value = {
      porter_id: '',
      department_id: '',
      service_id: '',
      start_datetime: new Date().toISOString().slice(0, 16),
      end_datetime: '',
      type: '',
      reason: ''
    }
  }
}, { immediate: true })

const onDepartmentChange = () => {
  // Clear service selection when department changes
  formData.value.service_id = ''
}

const fetchData = async () => {
  try {
    const [portersRes, departmentsRes, servicesRes] = await Promise.all([
      fetch('http://localhost:3001/api/porters'),
      fetch('http://localhost:3001/api/departments'),
      fetch('http://localhost:3001/api/services')
    ])

    const [portersData, departmentsData, servicesData] = await Promise.all([
      portersRes.json(),
      departmentsRes.json(),
      servicesRes.json()
    ])

    if (portersData.success) porters.value = portersData.data
    if (departmentsData.success) departments.value = departmentsData.data
    if (servicesData.success) services.value = servicesData.data
  } catch (error) {
    console.error('Error fetching data:', error)
  }
}

const handleSubmit = async () => {
  saving.value = true
  
  try {
    const url = props.allocation 
      ? `http://localhost:3001/api/allocations/${props.allocation.id}`
      : 'http://localhost:3001/api/allocations'
    
    const method = props.allocation ? 'PUT' : 'POST'
    
    const response = await fetch(url, {
      method,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(formData.value)
    })

    const result = await response.json()
    
    if (result.success) {
      emit('submit', result.data)
    } else {
      alert('Error: ' + result.error)
    }
  } catch (error) {
    console.error('Error saving allocation:', error)
    alert('Failed to save allocation')
  } finally {
    saving.value = false
  }
}

onMounted(() => {
  fetchData()
})
</script>

<style scoped>
.allocation-form {
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

.form-text {
  font-size: 0.75rem;
  color: #6b7280;
  margin-top: 0.25rem;
}

textarea.form-control {
  resize: vertical;
  min-height: 60px;
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
