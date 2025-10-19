<template>
  <form @submit.prevent="handleSubmit">
    <div class="form-group">
      <label for="name">Service Name *</label>
      <input 
        id="name"
        type="text" 
        v-model="form.name" 
        class="form-control"
        required
        placeholder="Enter service name"
      />
    </div>
    
    <div class="form-group">
      <label for="department_id">Department *</label>
      <select 
        id="department_id"
        v-model="form.department_id" 
        class="form-control"
        required
      >
        <option value="">Select a department</option>
        <option 
          v-for="department in departments" 
          :key="department.id" 
          :value="department.id"
        >
          {{ department.name }} ({{ department.building?.name }})
        </option>
      </select>
    </div>
    
    <div class="form-group">
      <label for="description">Description</label>
      <textarea 
        id="description"
        v-model="form.description" 
        class="form-control"
        rows="3"
        placeholder="Enter service description"
      ></textarea>
    </div>
    

    
    <div class="form-group">
      <label>
        <input 
          type="checkbox" 
          v-model="form.uses_custom_schedule"
        />
        Uses Custom Schedule
      </label>
      <small class="form-text">Check if this service has different hours than its department</small>
    </div>
  </form>
</template>

<script setup lang="ts">
import { ref, watch, computed } from 'vue'

interface Service {
  id?: string
  name: string
  department_id: string
  description?: string
  uses_custom_schedule: boolean
}

interface Department {
  id: string
  name: string
  building?: {
    name: string
  }
}

interface Props {
  service?: Service | null
  departments: Department[]
}

const props = defineProps<Props>()

const emit = defineEmits<{
  submit: [service: Service]
}>()

const form = ref<Service>({
  name: '',
  department_id: '',
  description: '',
  uses_custom_schedule: false
})

// Watch for changes to the service prop to populate form
watch(() => props.service, (service) => {
  if (service) {
    form.value = {
      id: service.id,
      name: service.name || '',
      department_id: service.department_id || '',
      description: service.description || '',
      uses_custom_schedule: service.uses_custom_schedule || false
    }
  } else {
    // Reset form for new service
    form.value = {
      name: '',
      department_id: '',
      description: '',
      uses_custom_schedule: false
    }
  }
}, { immediate: true })

const handleSubmit = () => {
  if (form.value.name.trim() && form.value.department_id) {
    emit('submit', { ...form.value })
  }
}

// Expose form validation
const isValid = computed(() => {
  return form.value.name.trim().length > 0 && form.value.department_id.length > 0
})

defineExpose({
  isValid,
  form
})
</script>
