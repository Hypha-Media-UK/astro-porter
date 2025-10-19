<template>
  <form @submit.prevent="handleSubmit" class="space-y-6">
    <!-- Basic Information -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="form-label">Capability Name *</label>
        <input
          v-model="formData.name"
          type="text"
          class="form-input"
          :class="{ 'border-red-500': errors.name }"
          placeholder="e.g., Patient Handling, Equipment Operation"
          required
        />
        <p v-if="errors.name" class="text-red-500 text-sm mt-1">{{ errors.name }}</p>
      </div>

      <div>
        <label class="form-label">Category</label>
        <select v-model="formData.category" class="form-select">
          <option value="PATIENT_CARE">Patient Care</option>
          <option value="EQUIPMENT">Equipment</option>
          <option value="SAFETY">Safety</option>
          <option value="TECHNICAL">Technical</option>
          <option value="ADMINISTRATIVE">Administrative</option>
          <option value="EMERGENCY">Emergency</option>
          <option value="SPECIALIZED">Specialized</option>
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
        placeholder="Detailed description of this capability and its requirements"
      ></textarea>
    </div>

    <!-- Certification Requirements -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="form-label">Certification Required</label>
        <select v-model="formData.certification_required" class="form-select">
          <option value="NONE">No Certification Required</option>
          <option value="BASIC">Basic Training</option>
          <option value="INTERMEDIATE">Intermediate Certification</option>
          <option value="ADVANCED">Advanced Certification</option>
          <option value="PROFESSIONAL">Professional License</option>
        </select>
      </div>

      <div>
        <label class="form-label">Certification Body</label>
        <input
          v-model="formData.certification_body"
          type="text"
          class="form-input"
          placeholder="e.g., NHS Trust, Royal College"
        />
      </div>
    </div>

    <!-- Training Requirements -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div>
        <label class="form-label">Training Duration (hours)</label>
        <input
          v-model.number="formData.training_hours"
          type="number"
          min="0"
          class="form-input"
          placeholder="e.g., 8"
        />
      </div>

      <div>
        <label class="form-label">Renewal Period (months)</label>
        <input
          v-model.number="formData.renewal_period"
          type="number"
          min="1"
          class="form-input"
          placeholder="e.g., 12"
        />
      </div>

      <div>
        <label class="form-label">Experience Required (months)</label>
        <input
          v-model.number="formData.experience_required"
          type="number"
          min="0"
          class="form-input"
          placeholder="e.g., 6"
        />
      </div>
    </div>

    <!-- Risk and Priority -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="form-label">Risk Level</label>
        <select v-model="formData.risk_level" class="form-select">
          <option value="LOW">Low Risk</option>
          <option value="MEDIUM">Medium Risk</option>
          <option value="HIGH">High Risk</option>
          <option value="CRITICAL">Critical Risk</option>
        </select>
      </div>

      <div>
        <label class="form-label">Priority Level</label>
        <select v-model="formData.priority_level" class="form-select">
          <option value="LOW">Low Priority</option>
          <option value="MEDIUM">Medium Priority</option>
          <option value="HIGH">High Priority</option>
          <option value="ESSENTIAL">Essential</option>
        </select>
      </div>
    </div>

    <!-- Prerequisites -->
    <div>
      <label class="form-label">Prerequisites</label>
      <textarea
        v-model="formData.prerequisites"
        class="form-input"
        rows="2"
        placeholder="List any prerequisite capabilities or qualifications"
      ></textarea>
    </div>

    <!-- Equipment and Resources -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="form-label">Required Equipment</label>
        <textarea
          v-model="formData.required_equipment"
          class="form-input"
          rows="2"
          placeholder="List any equipment required for this capability"
        ></textarea>
      </div>

      <div>
        <label class="form-label">Training Resources</label>
        <textarea
          v-model="formData.training_resources"
          class="form-input"
          rows="2"
          placeholder="List training materials or resources needed"
        ></textarea>
      </div>
    </div>

    <!-- Competency Assessment -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="form-label">Assessment Method</label>
        <select v-model="formData.assessment_method" class="form-select">
          <option value="PRACTICAL">Practical Assessment</option>
          <option value="WRITTEN">Written Exam</option>
          <option value="OBSERVATION">Direct Observation</option>
          <option value="SIMULATION">Simulation</option>
          <option value="PORTFOLIO">Portfolio Review</option>
          <option value="COMBINED">Combined Methods</option>
        </select>
      </div>

      <div>
        <label class="form-label">Pass Mark (%)</label>
        <input
          v-model.number="formData.pass_mark"
          type="number"
          min="0"
          max="100"
          class="form-input"
          placeholder="e.g., 80"
        />
      </div>
    </div>

    <!-- Compliance and Regulations -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="form-label">Regulatory Compliance</label>
        <input
          v-model="formData.regulatory_compliance"
          type="text"
          class="form-input"
          placeholder="e.g., CQC, NICE Guidelines"
        />
      </div>

      <div>
        <label class="form-label">Status</label>
        <select v-model="formData.status" class="form-select">
          <option value="ACTIVE">Active</option>
          <option value="INACTIVE">Inactive</option>
          <option value="UNDER_REVIEW">Under Review</option>
          <option value="DEPRECATED">Deprecated</option>
        </select>
      </div>
    </div>

    <!-- Additional Notes -->
    <div>
      <label class="form-label">Additional Notes</label>
      <textarea
        v-model="formData.notes"
        class="form-input"
        rows="3"
        placeholder="Any additional information or special considerations"
      ></textarea>
    </div>
  </form>
</template>

<script setup>
import { ref, watch } from 'vue'

const props = defineProps({
  capability: {
    type: Object,
    default: null
  }
})

const emit = defineEmits(['submit'])

// Form data
const formData = ref({
  name: '',
  category: 'PATIENT_CARE',
  description: '',
  certification_required: 'NONE',
  certification_body: '',
  training_hours: 0,
  renewal_period: 12,
  experience_required: 0,
  risk_level: 'LOW',
  priority_level: 'MEDIUM',
  prerequisites: '',
  required_equipment: '',
  training_resources: '',
  assessment_method: 'PRACTICAL',
  pass_mark: 80,
  regulatory_compliance: '',
  status: 'ACTIVE',
  notes: ''
})

// Validation errors
const errors = ref({})

// Watch for capability prop changes (for editing)
watch(() => props.capability, (newCapability) => {
  if (newCapability) {
    formData.value = {
      name: newCapability.name || '',
      category: newCapability.category || 'PATIENT_CARE',
      description: newCapability.description || '',
      certification_required: newCapability.certification_required || 'NONE',
      certification_body: newCapability.certification_body || '',
      training_hours: newCapability.training_hours || 0,
      renewal_period: newCapability.renewal_period || 12,
      experience_required: newCapability.experience_required || 0,
      risk_level: newCapability.risk_level || 'LOW',
      priority_level: newCapability.priority_level || 'MEDIUM',
      prerequisites: newCapability.prerequisites || '',
      required_equipment: newCapability.required_equipment || '',
      training_resources: newCapability.training_resources || '',
      assessment_method: newCapability.assessment_method || 'PRACTICAL',
      pass_mark: newCapability.pass_mark || 80,
      regulatory_compliance: newCapability.regulatory_compliance || '',
      status: newCapability.status || 'ACTIVE',
      notes: newCapability.notes || ''
    }
  } else {
    resetForm()
  }
}, { immediate: true })

// Methods
const resetForm = () => {
  formData.value = {
    name: '',
    category: 'PATIENT_CARE',
    description: '',
    certification_required: 'NONE',
    certification_body: '',
    training_hours: 0,
    renewal_period: 12,
    experience_required: 0,
    risk_level: 'LOW',
    priority_level: 'MEDIUM',
    prerequisites: '',
    required_equipment: '',
    training_resources: '',
    assessment_method: 'PRACTICAL',
    pass_mark: 80,
    regulatory_compliance: '',
    status: 'ACTIVE',
    notes: ''
  }
  errors.value = {}
}

const validateForm = () => {
  errors.value = {}
  
  if (!formData.value.name.trim()) {
    errors.value.name = 'Capability name is required'
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
