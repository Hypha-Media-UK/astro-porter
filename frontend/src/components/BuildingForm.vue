<template>
  <form @submit.prevent="handleSubmit">
    <div class="form-group">
      <label for="name">Building Name *</label>
      <input 
        id="name"
        type="text" 
        v-model="form.name" 
        class="form-control"
        required
        placeholder="Enter building name"
      />
    </div>
    
    <div class="form-group">
      <label for="location">Location</label>
      <input 
        id="location"
        type="text" 
        v-model="form.location" 
        class="form-control"
        placeholder="Enter building location/address"
      />
    </div>
    
    <div class="form-group">
      <label for="description">Description</label>
      <textarea 
        id="description"
        v-model="form.description" 
        class="form-control"
        rows="3"
        placeholder="Enter building description"
      ></textarea>
    </div>
  </form>
</template>

<script setup lang="ts">
import { ref, watch, computed } from 'vue'

interface Building {
  id?: string
  name: string
  location?: string
  description?: string
}

interface Props {
  building?: Building | null
}

const props = defineProps<Props>()

const emit = defineEmits<{
  submit: [building: Building]
}>()

const form = ref<Building>({
  name: '',
  location: '',
  description: ''
})

// Watch for changes to the building prop to populate form
watch(() => props.building, (building) => {
  if (building) {
    form.value = {
      id: building.id,
      name: building.name || '',
      location: building.location || '',
      description: building.description || ''
    }
  } else {
    // Reset form for new building
    form.value = {
      name: '',
      location: '',
      description: ''
    }
  }
}, { immediate: true })

const handleSubmit = () => {
  if (form.value.name.trim()) {
    emit('submit', { ...form.value })
  }
}

// Expose form validation
const isValid = computed(() => {
  return form.value.name.trim().length > 0
})

defineExpose({
  isValid,
  form
})
</script>
