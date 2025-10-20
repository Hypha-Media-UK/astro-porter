<template>
  <!-- Modal backdrop -->
  <div
    v-if="show"
    class="fixed inset-0 z-50 overflow-y-auto"
    aria-labelledby="modal-title"
    role="dialog"
    aria-modal="true"
  >
    <!-- Modern Background overlay -->
    <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
      <div
        class="fixed inset-0 bg-slate-900/50 backdrop-blur-sm transition-all duration-300"
        aria-hidden="true"
        @click="closeModal"
      ></div>

      <!-- This element is to trick the browser into centering the modal contents. -->
      <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>

      <!-- Modern Modal panel -->
      <div
        class="relative inline-block align-bottom glass rounded-2xl px-6 pt-6 pb-6 text-left overflow-hidden shadow-2xl transform transition-all duration-300 sm:my-8 sm:align-middle sm:max-w-lg sm:w-full border border-slate-200/60 dark:border-slate-800/60 animate-scale-in"
        :class="sizeClasses"
      >
        <!-- Modern Modal header -->
        <div class="flex items-center justify-between mb-6">
          <h3 class="text-xl font-bold text-slate-900 dark:text-slate-100 tracking-tight" id="modal-title">
            {{ title }}
          </h3>
          <button
            type="button"
            class="text-slate-400 hover:bg-slate-100 hover:text-slate-600 rounded-xl text-sm w-10 h-10 flex items-center justify-center transition-colors duration-200 dark:hover:bg-slate-800 dark:hover:text-slate-300"
            @click="closeModal"
          >
            <i class="fas fa-times"></i>
            <span class="sr-only">Close modal</span>
          </button>
        </div>

        <!-- Modal body -->
        <div class="modal-body">
          <slot></slot>
        </div>

        <!-- Modern Modal footer -->
        <div v-if="showFooter" class="flex items-center justify-end gap-3 mt-8 pt-6 border-t border-slate-200/60 dark:border-slate-800/60">
          <button
            v-if="showCancelButton"
            type="button"
            class="btn-secondary"
            @click="closeModal"
          >
            {{ cancelText }}
          </button>
          <button
            v-if="showSaveButton"
            type="button"
            class="btn-primary"
            :disabled="saveDisabled"
            @click="$emit('save')"
          >
            <i v-if="saving" class="fas fa-spinner fa-spin"></i>
            {{ saveText }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, watch } from 'vue'

// Props
const props = defineProps({
  show: {
    type: Boolean,
    default: false
  },
  title: {
    type: String,
    required: true
  },
  size: {
    type: String,
    default: 'md',
    validator: (value) => ['sm', 'md', 'lg', 'xl', '2xl'].includes(value)
  },
  showFooter: {
    type: Boolean,
    default: true
  },
  showCancelButton: {
    type: Boolean,
    default: true
  },
  showSaveButton: {
    type: Boolean,
    default: true
  },
  cancelText: {
    type: String,
    default: 'Cancel'
  },
  saveText: {
    type: String,
    default: 'Save'
  },
  saveDisabled: {
    type: Boolean,
    default: false
  },
  saving: {
    type: Boolean,
    default: false
  },
  closeOnBackdrop: {
    type: Boolean,
    default: true
  }
})

// Emits
const emit = defineEmits(['close', 'save'])

// Computed
const sizeClasses = computed(() => {
  const sizes = {
    sm: 'sm:max-w-sm',
    md: 'sm:max-w-lg',
    lg: 'sm:max-w-2xl',
    xl: 'sm:max-w-4xl',
    '2xl': 'sm:max-w-6xl'
  }
  return sizes[props.size] || sizes.md
})

// Methods
const closeModal = () => {
  if (props.closeOnBackdrop) {
    emit('close')
  }
}

// Handle escape key
const handleEscape = (event) => {
  if (event.key === 'Escape' && props.show) {
    closeModal()
  }
}

// Watch for show prop changes to handle body scroll
watch(() => props.show, (newValue) => {
  if (newValue) {
    document.body.style.overflow = 'hidden'
    document.addEventListener('keydown', handleEscape)
  } else {
    document.body.style.overflow = ''
    document.removeEventListener('keydown', handleEscape)
  }
})
</script>

<style scoped>
/* Additional modal styles if needed */
.modal-body {
  max-height: 70vh;
  overflow-y: auto;
}

/* Custom scrollbar for modal body */
.modal-body::-webkit-scrollbar {
  width: 6px;
}

.modal-body::-webkit-scrollbar-track {
  @apply bg-gray-100 dark:bg-gray-700;
}

.modal-body::-webkit-scrollbar-thumb {
  @apply bg-gray-300 dark:bg-gray-600 rounded-full;
}

.modal-body::-webkit-scrollbar-thumb:hover {
  @apply bg-gray-400 dark:bg-gray-500;
}
</style>
