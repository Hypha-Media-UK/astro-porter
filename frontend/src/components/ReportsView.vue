<template>
  <div class="reports-view">
    <div class="page-header">
      <h1>Reports & Analytics</h1>
      <p>Staffing forecasts, coverage analysis, and operational insights</p>
    </div>

    <!-- Report Type Selection -->
    <div class="report-selector">
      <div class="card">
        <h3>Select Report Type</h3>
        <div class="report-buttons">
          <button 
            v-for="report in reportTypes" 
            :key="report.id"
            @click="activeReport = report.id"
            :class="['btn', 'btn-outline', { 'btn-primary': activeReport === report.id }]"
          >
            {{ report.name }}
          </button>
        </div>
      </div>
    </div>

    <!-- Date Range Selector -->
    <div class="date-range-selector">
      <div class="card">
        <h3>Date Range</h3>
        <div class="date-inputs">
          <div class="form-group">
            <label>From Date</label>
            <input type="date" v-model="dateRange.from" class="form-control" />
          </div>
          <div class="form-group">
            <label>To Date</label>
            <input type="date" v-model="dateRange.to" class="form-control" />
          </div>
          <button class="btn btn-primary" @click="generateReport">
            Generate Report
          </button>
        </div>
      </div>
    </div>

    <!-- Report Content -->
    <div class="report-content">
      <!-- Staffing Forecast Report -->
      <div v-if="activeReport === 'staffing-forecast'" class="report-panel">
        <div class="card">
          <div class="card-header">
            <h3>Staffing Forecast</h3>
            <span class="report-period">{{ formatDateRange() }}</span>
          </div>
          
          <div class="forecast-grid">
            <div v-for="day in forecastData" :key="day.date" class="forecast-day">
              <div class="day-header">
                <h4>{{ formatDate(day.date) }}</h4>
                <span class="day-name">{{ getDayName(day.date) }}</span>
              </div>
              
              <div class="shifts">
                <div class="shift-block">
                  <h5>Day Shift (08:00-20:00)</h5>
                  <div class="staffing-summary">
                    <div class="metric">
                      <span class="label">Required:</span>
                      <span class="value">{{ day.day_shift.required }}</span>
                    </div>
                    <div class="metric">
                      <span class="label">Scheduled:</span>
                      <span class="value">{{ day.day_shift.scheduled }}</span>
                    </div>
                    <div class="metric">
                      <span class="label">Gap:</span>
                      <span :class="['value', getGapClass(day.day_shift.gap)]">
                        {{ day.day_shift.gap }}
                      </span>
                    </div>
                  </div>
                </div>
                
                <div class="shift-block">
                  <h5>Night Shift (20:00-08:00)</h5>
                  <div class="staffing-summary">
                    <div class="metric">
                      <span class="label">Required:</span>
                      <span class="value">{{ day.night_shift.required }}</span>
                    </div>
                    <div class="metric">
                      <span class="label">Scheduled:</span>
                      <span class="value">{{ day.night_shift.scheduled }}</span>
                    </div>
                    <div class="metric">
                      <span class="label">Gap:</span>
                      <span :class="['value', getGapClass(day.night_shift.gap)]">
                        {{ day.night_shift.gap }}
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Coverage Analysis Report -->
      <div v-if="activeReport === 'coverage-analysis'" class="report-panel">
        <div class="card">
          <div class="card-header">
            <h3>Coverage Analysis</h3>
            <span class="report-period">{{ formatDateRange() }}</span>
          </div>
          
          <div class="coverage-metrics">
            <div class="metric-card">
              <h4>Overall Coverage</h4>
              <div class="metric-value">{{ coverageData.overall }}%</div>
              <div class="metric-trend" :class="getTrendClass(coverageData.trend)">
                {{ coverageData.trend > 0 ? '↑' : '↓' }} {{ Math.abs(coverageData.trend) }}%
              </div>
            </div>
            
            <div class="metric-card">
              <h4>Critical Gaps</h4>
              <div class="metric-value">{{ coverageData.critical_gaps }}</div>
              <div class="metric-description">Shifts with <50% coverage</div>
            </div>
            
            <div class="metric-card">
              <h4>Avg Response Time</h4>
              <div class="metric-value">{{ coverageData.avg_response_time }}min</div>
              <div class="metric-description">To fill gaps</div>
            </div>
          </div>

          <div class="department-breakdown">
            <h4>Department Breakdown</h4>
            <table class="table">
              <thead>
                <tr>
                  <th>Department</th>
                  <th>Coverage %</th>
                  <th>Gaps</th>
                  <th>Status</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="dept in coverageData.departments" :key="dept.name">
                  <td>{{ dept.name }}</td>
                  <td>{{ dept.coverage }}%</td>
                  <td>{{ dept.gaps }}</td>
                  <td>
                    <span class="badge" :class="getCoverageStatusClass(dept.coverage)">
                      {{ getCoverageStatus(dept.coverage) }}
                    </span>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <!-- Relief Hours Report -->
      <div v-if="activeReport === 'relief-hours'" class="report-panel">
        <div class="card">
          <div class="card-header">
            <h3>Relief Porter Hours</h3>
            <span class="report-period">{{ formatDateRange() }}</span>
          </div>
          
          <table class="table">
            <thead>
              <tr>
                <th>Porter Name</th>
                <th>Guaranteed Hours</th>
                <th>Scheduled Hours</th>
                <th>Actual Hours</th>
                <th>Variance</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="porter in reliefHoursData" :key="porter.id">
                <td>{{ porter.name }}</td>
                <td>{{ porter.guaranteed_hours }}</td>
                <td>{{ porter.scheduled_hours }}</td>
                <td>{{ porter.actual_hours }}</td>
                <td :class="getVarianceClass(porter.variance)">
                  {{ porter.variance > 0 ? '+' : '' }}{{ porter.variance }}
                </td>
                <td>
                  <span class="badge" :class="getHoursStatusClass(porter.status)">
                    {{ porter.status }}
                  </span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Capability Expiry Report -->
      <div v-if="activeReport === 'capability-expiry'" class="report-panel">
        <div class="card">
          <div class="card-header">
            <h3>Capability Expiry Report</h3>
            <span class="report-period">Next 90 Days</span>
          </div>
          
          <div class="expiry-alerts">
            <div class="alert alert-danger" v-if="expiryData.expired.length > 0">
              <h4>Expired Capabilities ({{ expiryData.expired.length }})</h4>
              <ul>
                <li v-for="item in expiryData.expired" :key="item.id">
                  {{ item.porter_name }} - {{ item.capability_name }} (Expired {{ formatDate(item.expiry_date) }})
                </li>
              </ul>
            </div>
            
            <div class="alert alert-warning" v-if="expiryData.expiring_soon.length > 0">
              <h4>Expiring Soon ({{ expiryData.expiring_soon.length }})</h4>
              <ul>
                <li v-for="item in expiryData.expiring_soon" :key="item.id">
                  {{ item.porter_name }} - {{ item.capability_name }} (Expires {{ formatDate(item.expiry_date) }})
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'

// Report types
const reportTypes = [
  { id: 'staffing-forecast', name: 'Staffing Forecast' },
  { id: 'coverage-analysis', name: 'Coverage Analysis' },
  { id: 'relief-hours', name: 'Relief Hours' },
  { id: 'capability-expiry', name: 'Capability Expiry' }
]

const activeReport = ref('staffing-forecast')

// Date range
const dateRange = ref({
  from: new Date().toISOString().split('T')[0],
  to: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString().split('T')[0]
})

// Report data
const forecastData = ref([])
const coverageData = ref({
  overall: 85,
  trend: 2.5,
  critical_gaps: 3,
  avg_response_time: 15,
  departments: [
    { name: 'Radiology', coverage: 90, gaps: 1 },
    { name: 'Theatres', coverage: 75, gaps: 4 },
    { name: 'Pathology', coverage: 95, gaps: 0 }
  ]
})
const reliefHoursData = ref([])
const expiryData = ref({
  expired: [],
  expiring_soon: []
})

// Methods
const generateReport = async () => {
  console.log('Generating report:', activeReport.value, dateRange.value)
  
  // Mock data generation
  if (activeReport.value === 'staffing-forecast') {
    generateForecastData()
  } else if (activeReport.value === 'relief-hours') {
    generateReliefHoursData()
  } else if (activeReport.value === 'capability-expiry') {
    generateExpiryData()
  }
}

const generateForecastData = () => {
  const data = []
  const startDate = new Date(dateRange.value.from)
  const endDate = new Date(dateRange.value.to)
  
  for (let d = new Date(startDate); d <= endDate; d.setDate(d.getDate() + 1)) {
    const dayRequired = Math.floor(Math.random() * 5) + 8
    const dayScheduled = Math.floor(Math.random() * 3) + dayRequired - 2
    const nightRequired = Math.floor(Math.random() * 3) + 4
    const nightScheduled = Math.floor(Math.random() * 2) + nightRequired - 1
    
    data.push({
      date: new Date(d).toISOString().split('T')[0],
      day_shift: {
        required: dayRequired,
        scheduled: dayScheduled,
        gap: dayRequired - dayScheduled
      },
      night_shift: {
        required: nightRequired,
        scheduled: nightScheduled,
        gap: nightRequired - nightScheduled
      }
    })
  }
  
  forecastData.value = data
}

const generateReliefHoursData = () => {
  reliefHoursData.value = [
    {
      id: 1,
      name: 'Alice Johnson',
      guaranteed_hours: 40,
      scheduled_hours: 42,
      actual_hours: 38,
      variance: -2,
      status: 'Under'
    },
    {
      id: 2,
      name: 'Bob Wilson',
      guaranteed_hours: 35,
      scheduled_hours: 35,
      actual_hours: 37,
      variance: 2,
      status: 'Over'
    }
  ]
}

const generateExpiryData = () => {
  expiryData.value = {
    expired: [
      {
        id: 1,
        porter_name: 'John Smith',
        capability_name: 'Patient Transport',
        expiry_date: '2024-10-01'
      }
    ],
    expiring_soon: [
      {
        id: 2,
        porter_name: 'Jane Doe',
        capability_name: 'Equipment Handling',
        expiry_date: '2024-11-15'
      }
    ]
  }
}

// Utility methods
const formatDate = (date: string) => {
  return new Date(date).toLocaleDateString()
}

const formatDateRange = () => {
  return `${formatDate(dateRange.value.from)} - ${formatDate(dateRange.value.to)}`
}

const getDayName = (date: string) => {
  return new Date(date).toLocaleDateString('en-US', { weekday: 'short' })
}

const getGapClass = (gap: number) => {
  if (gap > 0) return 'text-danger'
  if (gap < 0) return 'text-success'
  return 'text-muted'
}

const getTrendClass = (trend: number) => {
  return trend > 0 ? 'text-success' : 'text-danger'
}

const getCoverageStatusClass = (coverage: number) => {
  if (coverage >= 90) return 'badge-success'
  if (coverage >= 75) return 'badge-warning'
  return 'badge-danger'
}

const getCoverageStatus = (coverage: number) => {
  if (coverage >= 90) return 'Good'
  if (coverage >= 75) return 'Fair'
  return 'Poor'
}

const getVarianceClass = (variance: number) => {
  if (variance > 0) return 'text-success'
  if (variance < 0) return 'text-danger'
  return 'text-muted'
}

const getHoursStatusClass = (status: string) => {
  switch (status) {
    case 'Over': return 'badge-success'
    case 'Under': return 'badge-danger'
    default: return 'badge-secondary'
  }
}

onMounted(() => {
  generateReport()
})
</script>
