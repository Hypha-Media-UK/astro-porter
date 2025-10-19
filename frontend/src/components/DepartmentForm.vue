<template>
  <form @submit.prevent="handleSubmit">
    <div class="form-group">
      <label for="name">Department Name *</label>
      <input 
        id="name"
        type="text" 
        v-model="form.name" 
        class="form-control"
        required
        placeholder="Enter department name"
      />
    </div>
    
    <div class="form-group">
      <label for="building_id">Building *</label>
      <select 
        id="building_id"
        v-model="form.building_id" 
        class="form-control"
        required
      >
        <option value="">Select a building</option>
        <option 
          v-for="building in buildings" 
          :key="building.id" 
          :value="building.id"
        >
          {{ building.name }}
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
        placeholder="Enter department description"
      ></textarea>
    </div>
    
    <div class="form-group">
      <label>
        <input 
          type="checkbox" 
          v-model="form.is_24_7"
        />
        24/7 Operations
      </label>
      <small class="form-text">Check if this department operates 24 hours a day</small>
    </div>
  </form>
</template>

<script setup lang="ts">
import { ref, watch, computed } from 'vue'

interface Department {
  id?: string
  name: string
  building_id: string
  description?: string
  is_24_7: boolean
}

interface Building {
  id: string
  name: string
}

interface Props {
  department?: Department | null
  buildings: Building[]
}

const props = defineProps<Props>()

const emit = defineEmits<{
  submit: [department: Department]
}>()

const form = ref<Department>({
  name: '',
  building_id: '',
  description: '',
  is_24_7: false
})

// Watch for changes to the department prop to populate form
watch(() => props.department, (department) => {
  if (department) {
    form.value = {
      id: department.id,
      name: department.name || '',
      building_id: department.building_id || '',
      description: department.description || '',
      is_24_7: department.is_24_7 || false
    }
  } else {
    // Reset form for new department
    form.value = {
      name: '',
      building_id: '',
      description: '',
      is_24_7: false
    }
  }
}, { immediate: true })

const handleSubmit = () => {
  if (form.value.name.trim() && form.value.building_id) {
    emit('submit', { ...form.value })
  }
}

// Expose form validation
const isValid = computed(() => {
  return form.value.name.trim().length > 0 && form.value.building_id.length > 0
})

defineExpose({
  isValid,
  form
})
</script>
