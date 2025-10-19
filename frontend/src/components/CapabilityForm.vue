<template>
  <form @submit.prevent="handleSubmit" class="capability-form">
    <div class="form-group">
      <label for="name">Capability Name *</label>
      <input
        id="name"
        v-model="formData.name"
        type="text"
        class="form-control"
        required
        placeholder="e.g., Patient Transport, Specimen Collection"
      />
    </div>

    <div class="form-group">
      <label for="description">Description</label>
      <textarea
        id="description"
        v-model="formData.description"
        class="form-control"
        rows="3"
        placeholder="Detailed description of the capability requirements..."
      ></textarea>
    </div>

    <div class="form-actions">
      <button type="button" @click="$emit('cancel')" class="btn btn-secondary">
        Cancel
      </button>
      <button type="submit" class="btn btn-primary" :disabled="saving">
        {{ saving ? 'Saving...' : (capability ? 'Update' : 'Create') }} Capability
      </button>
    </div>
  </form>
</template>

<script setup>
import { ref, watch, onMounted } from 'vue'

const props = defineProps({
  capability: {
    type: Object,
    default: null
  }
})

const emit = defineEmits(['submit', 'cancel'])

const formData = ref({
  name: '',
  description: ''
})

const saving = ref(false)

// Watch for capability changes (edit mode)
watch(() => props.capability, (newCapability) => {
  if (newCapability) {
    formData.value = {
      name: newCapability.name || '',
      description: newCapability.description || ''
    }
  } else {
    // Reset form for create mode
    formData.value = {
      name: '',
      description: ''
    }
  }
}, { immediate: true })

const handleSubmit = async () => {
  saving.value = true
  
  try {
    const url = props.capability 
      ? `http://localhost:3001/api/capabilities/${props.capability.id}`
      : 'http://localhost:3001/api/capabilities'
    
    const method = props.capability ? 'PUT' : 'POST'
    
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
    console.error('Error saving capability:', error)
    alert('Failed to save capability')
  } finally {
    saving.value = false
  }
}

onMounted(() => {
  // Focus on name field when form opens
  const nameInput = document.getElementById('name')
  if (nameInput) {
    nameInput.focus()
  }
})
</script>

<style scoped>
.capability-form {
  max-width: 500px;
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

textarea.form-control {
  resize: vertical;
  min-height: 80px;
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
</style>
