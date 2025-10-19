<template>
  <form @submit.prevent="handleSubmit">
    <div class="form-group">
      <label for="name">Porter Name *</label>
      <input 
        id="name"
        type="text" 
        v-model="form.name" 
        class="form-control"
        required
        placeholder="Enter porter name"
      />
    </div>
    
    <div class="form-group">
      <label for="contract_type">Contract Type *</label>
      <select 
        id="contract_type"
        v-model="form.contract_type" 
        class="form-control"
        required
      >
        <option value="">Select contract type</option>
        <option value="SHIFT">Shift</option>
        <option value="FIXED">Fixed</option>
        <option value="RELIEF">Relief</option>
      </select>
    </div>
    
    <div class="form-group">
      <label for="porter_type">Porter Type</label>
      <select 
        id="porter_type"
        v-model="form.porter_type" 
        class="form-control"
      >
        <option value="PORTER">Porter</option>
        <option value="SUPERVISOR">Supervisor</option>
      </select>
    </div>
    
    <div class="form-group">
      <label for="regular_department_id">Regular Department</label>
      <select 
        id="regular_department_id"
        v-model="form.regular_department_id" 
        class="form-control"
      >
        <option value="">No regular department</option>
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
      <label for="shift_id">Shift Pattern</label>
      <select 
        id="shift_id"
        v-model="form.shift_id" 
        class="form-control"
      >
        <option value="">No shift pattern</option>
        <option 
          v-for="shift in shifts" 
          :key="shift.id" 
          :value="shift.id"
        >
          {{ shift.name }}
        </option>
      </select>
    </div>
    
    <div class="form-group">
      <label for="weekly_min_hours">Weekly Minimum Hours</label>
      <input 
        id="weekly_min_hours"
        type="number" 
        v-model.number="form.weekly_min_hours" 
        class="form-control"
        min="0"
        max="168"
        placeholder="Minimum hours per week"
      />
    </div>
    
    <div class="form-group">
      <label for="contracted_hours">Contracted Hours</label>
      <input 
        id="contracted_hours"
        type="number" 
        v-model.number="form.contracted_hours" 
        class="form-control"
        min="0"
        max="168"
        placeholder="Contracted hours per week"
      />
    </div>
    
    <div class="form-group">
      <label>
        <input 
          type="checkbox" 
          v-model="form.counts_towards_staffing"
        />
        Counts Towards Staffing
      </label>
      <small class="form-text">Include this porter in staffing calculations</small>
    </div>
  </form>
</template>

<script setup lang="ts">
import { ref, watch, computed } from 'vue'

interface Porter {
  id?: string
  name: string
  contract_type: string
  porter_type: string
  regular_department_id?: string
  shift_id?: string
  weekly_min_hours?: number
  contracted_hours?: number
  counts_towards_staffing: boolean
}

interface Department {
  id: string
  name: string
  building?: {
    name: string
  }
}

interface Shift {
  id: string
  name: string
}

interface Props {
  porter?: Porter | null
  departments: Department[]
  shifts: Shift[]
}

const props = defineProps<Props>()

const emit = defineEmits<{
  submit: [porter: Porter]
}>()

const form = ref<Porter>({
  name: '',
  contract_type: '',
  porter_type: 'PORTER',
  regular_department_id: '',
  shift_id: '',
  weekly_min_hours: undefined,
  contracted_hours: undefined,
  counts_towards_staffing: true
})

// Watch for changes to the porter prop to populate form
watch(() => props.porter, (porter) => {
  if (porter) {
    form.value = {
      id: porter.id,
      name: porter.name || '',
      contract_type: porter.contract_type || '',
      porter_type: porter.porter_type || 'PORTER',
      regular_department_id: porter.regular_department_id || '',
      shift_id: porter.shift_id || '',
      weekly_min_hours: porter.weekly_min_hours,
      contracted_hours: porter.contracted_hours,
      counts_towards_staffing: porter.counts_towards_staffing ?? true
    }
  } else {
    // Reset form for new porter
    form.value = {
      name: '',
      contract_type: '',
      porter_type: 'PORTER',
      regular_department_id: '',
      shift_id: '',
      weekly_min_hours: undefined,
      contracted_hours: undefined,
      counts_towards_staffing: true
    }
  }
}, { immediate: true })

const handleSubmit = () => {
  if (form.value.name.trim() && form.value.contract_type) {
    emit('submit', { ...form.value })
  }
}

// Expose form validation
const isValid = computed(() => {
  return form.value.name.trim().length > 0 && form.value.contract_type.length > 0
})

defineExpose({
  isValid,
  form
})
</script>
