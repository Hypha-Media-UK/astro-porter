<template>
  <div class="reports-view">
    <!-- Reports Overview Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-6">
      <!-- Total Reports -->
      <div class="stats-card">
        <div class="flex items-center">
          <div class="flex-shrink-0">
            <div class="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center dark:bg-blue-900">
              <i class="fas fa-chart-bar text-blue-600 dark:text-blue-300"></i>
            </div>
          </div>
          <div class="ml-4">
            <p class="stats-label">Available Reports</p>
            <p class="stats-value">12</p>
          </div>
        </div>
      </div>

      <!-- Last Generated -->
      <div class="stats-card">
        <div class="flex items-center">
          <div class="flex-shrink-0">
            <div class="w-8 h-8 bg-green-100 rounded-lg flex items-center justify-center dark:bg-green-900">
              <i class="fas fa-clock text-green-600 dark:text-green-300"></i>
            </div>
          </div>
          <div class="ml-4">
            <p class="stats-label">Last Generated</p>
            <p class="stats-value text-sm">{{ lastGenerated }}</p>
          </div>
        </div>
      </div>

      <!-- Data Range -->
      <div class="stats-card">
        <div class="flex items-center">
          <div class="flex-shrink-0">
            <div class="w-8 h-8 bg-purple-100 rounded-lg flex items-center justify-center dark:bg-purple-900">
              <i class="fas fa-calendar text-purple-600 dark:text-purple-300"></i>
            </div>
          </div>
          <div class="ml-4">
            <p class="stats-label">Data Range</p>
            <p class="stats-value text-sm">30 Days</p>
          </div>
        </div>
      </div>

      <!-- Export Format -->
      <div class="stats-card">
        <div class="flex items-center">
          <div class="flex-shrink-0">
            <div class="w-8 h-8 bg-orange-100 rounded-lg flex items-center justify-center dark:bg-orange-900">
              <i class="fas fa-file-export text-orange-600 dark:text-orange-300"></i>
            </div>
          </div>
          <div class="ml-4">
            <p class="stats-label">Export Formats</p>
            <p class="stats-value text-sm">PDF, Excel</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Report Categories -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
      <!-- Staffing Reports -->
      <div class="card">
        <div class="card-header">
          <h3 class="card-title">
            <i class="fas fa-users mr-2"></i>
            Staffing Reports
          </h3>
        </div>
        <div class="card-body">
          <div class="space-y-4">
            <div class="report-item">
              <div class="flex items-center justify-between">
                <div>
                  <h4 class="text-sm font-medium text-gray-900 dark:text-white">Daily Staffing Summary</h4>
                  <p class="text-sm text-gray-500 dark:text-gray-400">Overview of daily porter assignments and coverage</p>
                </div>
                <button class="btn-primary btn-sm">
                  <i class="fas fa-download mr-1"></i>
                  Generate
                </button>
              </div>
            </div>

            <div class="report-item">
              <div class="flex items-center justify-between">
                <div>
                  <h4 class="text-sm font-medium text-gray-900 dark:text-white">Weekly Coverage Analysis</h4>
                  <p class="text-sm text-gray-500 dark:text-gray-400">Detailed analysis of weekly coverage patterns</p>
                </div>
                <button class="btn-primary btn-sm">
                  <i class="fas fa-download mr-1"></i>
                  Generate
                </button>
              </div>
            </div>

            <div class="report-item">
              <div class="flex items-center justify-between">
                <div>
                  <h4 class="text-sm font-medium text-gray-900 dark:text-white">Porter Utilization</h4>
                  <p class="text-sm text-gray-500 dark:text-gray-400">Individual porter workload and utilization rates</p>
                </div>
                <button class="btn-primary btn-sm">
                  <i class="fas fa-download mr-1"></i>
                  Generate
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Operational Reports -->
      <div class="card">
        <div class="card-header">
          <h3 class="card-title">
            <i class="fas fa-chart-line mr-2"></i>
            Operational Reports
          </h3>
        </div>
        <div class="card-body">
          <div class="space-y-4">
            <div class="report-item">
              <div class="flex items-center justify-between">
                <div>
                  <h4 class="text-sm font-medium text-gray-900 dark:text-white">Department Performance</h4>
                  <p class="text-sm text-gray-500 dark:text-gray-400">Performance metrics by department</p>
                </div>
                <button class="btn-primary btn-sm">
                  <i class="fas fa-download mr-1"></i>
                  Generate
                </button>
              </div>
            </div>

            <div class="report-item">
              <div class="flex items-center justify-between">
                <div>
                  <h4 class="text-sm font-medium text-gray-900 dark:text-white">Shift Pattern Analysis</h4>
                  <p class="text-sm text-gray-500 dark:text-gray-400">Analysis of shift patterns and effectiveness</p>
                </div>
                <button class="btn-primary btn-sm">
                  <i class="fas fa-download mr-1"></i>
                  Generate
                </button>
              </div>
            </div>

            <div class="report-item">
              <div class="flex items-center justify-between">
                <div>
                  <h4 class="text-sm font-medium text-gray-900 dark:text-white">Overtime Analysis</h4>
                  <p class="text-sm text-gray-500 dark:text-gray-400">Overtime usage and cost analysis</p>
                </div>
                <button class="btn-primary btn-sm">
                  <i class="fas fa-download mr-1"></i>
                  Generate
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Custom Reports -->
      <div class="card">
        <div class="card-header">
          <h3 class="card-title">
            <i class="fas fa-cogs mr-2"></i>
            Custom Reports
          </h3>
        </div>
        <div class="card-body">
          <div class="space-y-4">
            <div class="report-item">
              <div class="flex items-center justify-between">
                <div>
                  <h4 class="text-sm font-medium text-gray-900 dark:text-white">Custom Query Builder</h4>
                  <p class="text-sm text-gray-500 dark:text-gray-400">Build custom reports with advanced filters</p>
                </div>
                <button class="btn-secondary btn-sm">
                  <i class="fas fa-tools mr-1"></i>
                  Build
                </button>
              </div>
            </div>

            <div class="report-item">
              <div class="flex items-center justify-between">
                <div>
                  <h4 class="text-sm font-medium text-gray-900 dark:text-white">Scheduled Reports</h4>
                  <p class="text-sm text-gray-500 dark:text-gray-400">Set up automated report generation</p>
                </div>
                <button class="btn-secondary btn-sm">
                  <i class="fas fa-calendar mr-1"></i>
                  Schedule
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Export Options -->
      <div class="card">
        <div class="card-header">
          <h3 class="card-title">
            <i class="fas fa-file-export mr-2"></i>
            Export Options
          </h3>
        </div>
        <div class="card-body">
          <div class="space-y-4">
            <div>
              <label class="form-label">Date Range</label>
              <div class="grid grid-cols-2 gap-2">
                <input type="date" class="form-input" v-model="dateFrom" />
                <input type="date" class="form-input" v-model="dateTo" />
              </div>
            </div>

            <div>
              <label class="form-label">Format</label>
              <select class="form-select" v-model="exportFormat">
                <option value="pdf">PDF Report</option>
                <option value="excel">Excel Spreadsheet</option>
                <option value="csv">CSV Data</option>
              </select>
            </div>

            <div>
              <label class="form-label">Include</label>
              <div class="space-y-2">
                <label class="flex items-center">
                  <input type="checkbox" class="form-checkbox" v-model="includeCharts" />
                  <span class="ml-2 text-sm text-gray-700 dark:text-gray-300">Charts and graphs</span>
                </label>
                <label class="flex items-center">
                  <input type="checkbox" class="form-checkbox" v-model="includeRawData" />
                  <span class="ml-2 text-sm text-gray-700 dark:text-gray-300">Raw data tables</span>
                </label>
              </div>
            </div>

            <button class="btn-primary w-full">
              <i class="fas fa-download mr-2"></i>
              Export Report
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Coming Soon Notice -->
    <div class="mt-8 card">
      <div class="card-body text-center">
        <i class="fas fa-chart-bar text-4xl text-gray-400 mb-4"></i>
        <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Advanced Analytics Coming Soon</h3>
        <p class="text-gray-500 dark:text-gray-400">
          We're working on advanced analytics features including real-time dashboards, 
          predictive analytics, and automated insights.
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

// Reactive data
const dateFrom = ref(new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString().split('T')[0])
const dateTo = ref(new Date().toISOString().split('T')[0])
const exportFormat = ref('pdf')
const includeCharts = ref(true)
const includeRawData = ref(false)

// Computed
const lastGenerated = computed(() => {
  const now = new Date()
  return now.toLocaleString('en-GB', {
    day: '2-digit',
    month: 'short',
    hour: '2-digit',
    minute: '2-digit'
  })
})
</script>

<style scoped>
.report-item {
  @apply p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors duration-200 dark:border-gray-600 dark:hover:bg-gray-700;
}

.btn-sm {
  @apply px-3 py-1.5 text-xs;
}

.form-checkbox {
  @apply w-4 h-4 text-primary-600 bg-gray-100 border-gray-300 rounded focus:ring-primary-500 dark:focus:ring-primary-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600;
}
</style>
