<template>
  <form @submit.prevent="handleSubmit" class="space-y-8">
    <!-- General Settings -->
    <div class="card">
      <div class="card-header">
        <h3 class="card-title">General Settings</h3>
      </div>
      <div class="card-body space-y-6">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <label class="form-label">System Name</label>
            <input
              v-model="formData.system_name"
              type="text"
              class="form-input"
              placeholder="Porter Management System"
            />
          </div>

          <div>
            <label class="form-label">Organization Name</label>
            <input
              v-model="formData.organization_name"
              type="text"
              class="form-input"
              placeholder="Hospital Trust Name"
            />
          </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <label class="form-label">Default Timezone</label>
            <select v-model="formData.timezone" class="form-select">
              <option value="Europe/London">Europe/London (GMT)</option>
              <option value="Europe/Dublin">Europe/Dublin (GMT)</option>
              <option value="UTC">UTC</option>
            </select>
          </div>

          <div>
            <label class="form-label">Date Format</label>
            <select v-model="formData.date_format" class="form-select">
              <option value="DD/MM/YYYY">DD/MM/YYYY</option>
              <option value="MM/DD/YYYY">MM/DD/YYYY</option>
              <option value="YYYY-MM-DD">YYYY-MM-DD</option>
            </select>
          </div>
        </div>
      </div>
    </div>

    <!-- Shift Management Settings -->
    <div class="card">
      <div class="card-header">
        <h3 class="card-title">Shift Management</h3>
      </div>
      <div class="card-body space-y-6">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div>
            <label class="form-label">Default Shift Duration (hours)</label>
            <input
              v-model.number="formData.default_shift_duration"
              type="number"
              min="1"
              max="24"
              class="form-input"
              placeholder="8"
            />
          </div>

          <div>
            <label class="form-label">Minimum Break Duration (minutes)</label>
            <input
              v-model.number="formData.min_break_duration"
              type="number"
              min="0"
              class="form-input"
              placeholder="15"
            />
          </div>

          <div>
            <label class="form-label">Maximum Consecutive Days</label>
            <input
              v-model.number="formData.max_consecutive_days"
              type="number"
              min="1"
              max="14"
              class="form-input"
              placeholder="7"
            />
          </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <label class="form-label">Overtime Rate Multiplier</label>
            <input
              v-model.number="formData.overtime_rate"
              type="number"
              min="1"
              step="0.1"
              class="form-input"
              placeholder="1.5"
            />
          </div>

          <div>
            <label class="form-label">Night Shift Allowance (£)</label>
            <input
              v-model.number="formData.night_allowance"
              type="number"
              min="0"
              step="0.01"
              class="form-input"
              placeholder="15.00"
            />
          </div>
        </div>
      </div>
    </div>

    <!-- Notification Settings -->
    <div class="card">
      <div class="card-header">
        <h3 class="card-title">Notifications</h3>
      </div>
      <div class="card-body space-y-6">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div class="space-y-4">
            <label class="flex items-center">
              <input
                v-model="formData.email_notifications"
                type="checkbox"
                class="form-checkbox"
              />
              <span class="ml-2 text-sm text-gray-700 dark:text-gray-300">Enable Email Notifications</span>
            </label>

            <label class="flex items-center">
              <input
                v-model="formData.sms_notifications"
                type="checkbox"
                class="form-checkbox"
              />
              <span class="ml-2 text-sm text-gray-700 dark:text-gray-300">Enable SMS Notifications</span>
            </label>

            <label class="flex items-center">
              <input
                v-model="formData.shift_reminders"
                type="checkbox"
                class="form-checkbox"
              />
              <span class="ml-2 text-sm text-gray-700 dark:text-gray-300">Send Shift Reminders</span>
            </label>
          </div>

          <div class="space-y-4">
            <div>
              <label class="form-label">Reminder Time (hours before shift)</label>
              <input
                v-model.number="formData.reminder_hours"
                type="number"
                min="1"
                max="48"
                class="form-input"
                placeholder="2"
              />
            </div>

            <div>
              <label class="form-label">Admin Email</label>
              <input
                v-model="formData.admin_email"
                type="email"
                class="form-input"
                placeholder="admin@hospital.nhs.uk"
              />
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Coverage Settings -->
    <div class="card">
      <div class="card-header">
        <h3 class="card-title">Coverage Requirements</h3>
      </div>
      <div class="card-body space-y-6">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div>
            <label class="form-label">Minimum Coverage Percentage</label>
            <input
              v-model.number="formData.min_coverage_percentage"
              type="number"
              min="0"
              max="100"
              class="form-input"
              placeholder="80"
            />
          </div>

          <div>
            <label class="form-label">Critical Coverage Threshold</label>
            <input
              v-model.number="formData.critical_threshold"
              type="number"
              min="0"
              max="100"
              class="form-input"
              placeholder="50"
            />
          </div>

          <div>
            <label class="form-label">Auto-assign Priority</label>
            <select v-model="formData.auto_assign_priority" class="form-select">
              <option value="DISABLED">Disabled</option>
              <option value="LOW">Low Priority Only</option>
              <option value="MEDIUM">Medium and Below</option>
              <option value="HIGH">High and Below</option>
              <option value="ALL">All Priorities</option>
            </select>
          </div>
        </div>
      </div>
    </div>

    <!-- Security Settings -->
    <div class="card">
      <div class="card-header">
        <h3 class="card-title">Security & Compliance</h3>
      </div>
      <div class="card-body space-y-6">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <label class="form-label">Data Retention Period (months)</label>
            <input
              v-model.number="formData.data_retention_months"
              type="number"
              min="1"
              max="120"
              class="form-input"
              placeholder="24"
            />
          </div>

          <div>
            <label class="form-label">Backup Frequency</label>
            <select v-model="formData.backup_frequency" class="form-select">
              <option value="DAILY">Daily</option>
              <option value="WEEKLY">Weekly</option>
              <option value="MONTHLY">Monthly</option>
            </select>
          </div>
        </div>

        <div class="space-y-4">
          <label class="flex items-center">
            <input
              v-model="formData.audit_logging"
              type="checkbox"
              class="form-checkbox"
            />
            <span class="ml-2 text-sm text-gray-700 dark:text-gray-300">Enable Audit Logging</span>
          </label>

          <label class="flex items-center">
            <input
              v-model="formData.gdpr_compliance"
              type="checkbox"
              class="form-checkbox"
            />
            <span class="ml-2 text-sm text-gray-700 dark:text-gray-300">GDPR Compliance Mode</span>
          </label>
        </div>
      </div>
    </div>

    <!-- Integration Settings -->
    <div class="card">
      <div class="card-header">
        <h3 class="card-title">System Integrations</h3>
      </div>
      <div class="card-body space-y-6">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <label class="form-label">HR System API Endpoint</label>
            <input
              v-model="formData.hr_api_endpoint"
              type="url"
              class="form-input"
              placeholder="https://hr.hospital.nhs.uk/api"
            />
          </div>

          <div>
            <label class="form-label">Payroll System Integration</label>
            <select v-model="formData.payroll_integration" class="form-select">
              <option value="DISABLED">Disabled</option>
              <option value="SAGE">Sage</option>
              <option value="SAP">SAP</option>
              <option value="CUSTOM">Custom API</option>
            </select>
          </div>
        </div>
      </div>
    </div>
  </form>
</template>

<script setup>
import { ref, watch } from 'vue'

const props = defineProps({
  settings: {
    type: Object,
    default: null
  }
})

const emit = defineEmits(['submit'])

// Form data
const formData = ref({
  system_name: 'Porter Management System',
  organization_name: '',
  timezone: 'Europe/London',
  date_format: 'DD/MM/YYYY',
  default_shift_duration: 8,
  min_break_duration: 15,
  max_consecutive_days: 7,
  overtime_rate: 1.5,
  night_allowance: 15.00,
  email_notifications: true,
  sms_notifications: false,
  shift_reminders: true,
  reminder_hours: 2,
  admin_email: '',
  min_coverage_percentage: 80,
  critical_threshold: 50,
  auto_assign_priority: 'MEDIUM',
  data_retention_months: 24,
  backup_frequency: 'DAILY',
  audit_logging: true,
  gdpr_compliance: true,
  hr_api_endpoint: '',
  payroll_integration: 'DISABLED'
})

// Watch for settings prop changes (for editing)
watch(() => props.settings, (newSettings) => {
  if (newSettings) {
    Object.keys(formData.value).forEach(key => {
      if (newSettings[key] !== undefined) {
        formData.value[key] = newSettings[key]
      }
    })
  } else {
    resetForm()
  }
}, { immediate: true })

// Methods
const resetForm = () => {
  formData.value = {
    system_name: 'Porter Management System',
    organization_name: '',
    timezone: 'Europe/London',
    date_format: 'DD/MM/YYYY',
    default_shift_duration: 8,
    min_break_duration: 15,
    max_consecutive_days: 7,
    overtime_rate: 1.5,
    night_allowance: 15.00,
    email_notifications: true,
    sms_notifications: false,
    shift_reminders: true,
    reminder_hours: 2,
    admin_email: '',
    min_coverage_percentage: 80,
    critical_threshold: 50,
    auto_assign_priority: 'MEDIUM',
    data_retention_months: 24,
    backup_frequency: 'DAILY',
    audit_logging: true,
    gdpr_compliance: true,
    hr_api_endpoint: '',
    payroll_integration: 'DISABLED'
  }
}

const validateForm = () => {
  return true // Settings form doesn't require strict validation
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
