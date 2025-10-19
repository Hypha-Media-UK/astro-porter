<template>
  <form @submit.prevent ref="formRef">
    <div class="form-group">
      <label for="name">Name *</label>
      <input 
        type="text" 
        id="name" 
        v-model="form.name" 
        required 
        placeholder="e.g., Day Shift A"
      />
    </div>

    <div class="form-group">
      <label for="description">Description</label>
      <textarea 
        id="description" 
        v-model="form.description" 
        rows="3"
        placeholder="Optional description of the shift pattern"
      ></textarea>
    </div>



    <div class="form-group">
      <label>Shift Pattern *</label>
      <div class="pattern-builder">
        <div v-for="(segment, index) in form.pattern" :key="index" class="pattern-segment">
          <div class="segment-row">
            <select v-model="segment.type" required>
              <option value="">Select type</option>
              <option value="ON">On Duty</option>
              <option value="OFF">Off Duty</option>
              <option value="TRAINING">Training</option>
              <option value="LEAVE">Leave</option>
            </select>
            
            <input 
              type="text" 
              v-model="segment.label" 
              placeholder="Label (e.g., Day 1-4)"
              required
            />
            
            <input 
              type="number" 
              v-model.number="segment.duration_days" 
              placeholder="Days"
              min="1"
              required
            />
            
            <button 
              type="button" 
              @click="removeSegment(index)"
              class="btn-remove"
              :disabled="form.pattern.length <= 1"
            >
              ×
            </button>
          </div>
        </div>
        
        <button type="button" @click="addSegment" class="btn-add">
          + Add Segment
        </button>
      </div>
      <small>Define the repeating pattern of work and rest periods</small>
    </div>
  </form>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'

interface ShiftSegment {
  type: string
  label: string
  duration_days: number
}

interface ShiftPatternForm {
  name: string
  description: string
  pattern: ShiftSegment[]
}

const props = defineProps<{
  shiftPattern?: any
}>()

const formRef = ref<HTMLFormElement>()

const form = ref<ShiftPatternForm>({
  name: '',
  description: '',
  pattern: [
    { type: 'ON', label: 'Days 1-4', duration_days: 4 },
    { type: 'OFF', label: 'Days 5-8', duration_days: 4 }
  ]
})

const isValid = computed(() => {
  return form.value.name.trim() &&
         form.value.pattern.length > 0 &&
         form.value.pattern.every(segment =>
           segment.type && segment.label.trim() && segment.duration_days > 0
         )
})

const addSegment = () => {
  form.value.pattern.push({
    type: '',
    label: '',
    duration_days: 1
  })
}

const removeSegment = (index: number) => {
  if (form.value.pattern.length > 1) {
    form.value.pattern.splice(index, 1)
  }
}

// Watch for prop changes to populate form for editing
watch(() => props.shiftPattern, (newShiftPattern) => {
  if (newShiftPattern) {
    form.value = {
      name: newShiftPattern.name || '',
      description: newShiftPattern.description || '',
      pattern: newShiftPattern.patternJson ?
        JSON.parse(newShiftPattern.patternJson) :
        [
          { type: 'ON', label: 'Days 1-4', duration_days: 4 },
          { type: 'OFF', label: 'Days 5-8', duration_days: 4 }
        ]
    }
  } else {
    // Reset form for new shift pattern
    form.value = {
      name: '',
      description: '',
      pattern: [
        { type: 'ON', label: 'Days 1-4', duration_days: 4 },
        { type: 'OFF', label: 'Days 5-8', duration_days: 4 }
      ]
    }
  }
}, { immediate: true })

defineExpose({
  form,
  isValid,
  formRef
})
</script>

<style scoped>
.form-group {
  margin-bottom: 1rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.25rem;
  font-weight: 500;
}

.form-group input,
.form-group textarea,
.form-group select {
  width: 100%;
  padding: 0.5rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 0.9rem;
}

.form-group small {
  display: block;
  margin-top: 0.25rem;
  color: #666;
  font-size: 0.8rem;
}

.pattern-builder {
  border: 1px solid #ddd;
  border-radius: 4px;
  padding: 1rem;
  background: #f9f9f9;
}

.pattern-segment {
  margin-bottom: 0.75rem;
}

.segment-row {
  display: grid;
  grid-template-columns: 120px 1fr 80px 40px;
  gap: 0.5rem;
  align-items: center;
}

.btn-remove {
  background: #dc3545;
  color: white;
  border: none;
  border-radius: 4px;
  width: 32px;
  height: 32px;
  cursor: pointer;
  font-size: 1.2rem;
  display: flex;
  align-items: center;
  justify-content: center;
}

.btn-remove:disabled {
  background: #ccc;
  cursor: not-allowed;
}

.btn-add {
  background: #28a745;
  color: white;
  border: none;
  border-radius: 4px;
  padding: 0.5rem 1rem;
  cursor: pointer;
  font-size: 0.9rem;
}

.btn-add:hover {
  background: #218838;
}

.btn-remove:hover:not(:disabled) {
  background: #c82333;
}
</style>
