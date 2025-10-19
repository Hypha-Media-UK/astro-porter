<template>
  <!-- Modal backdrop -->
  <div
    v-if="show"
    class="fixed inset-0 z-50 overflow-y-auto"
    aria-labelledby="modal-title"
    role="dialog"
    aria-modal="true"
  >
    <!-- Background overlay -->
    <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
      <div
        class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"
        aria-hidden="true"
        @click="closeModal"
      ></div>

      <!-- This element is to trick the browser into centering the modal contents. -->
      <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>

      <!-- Modal panel -->
      <div
        class="relative inline-block align-bottom bg-white rounded-lg px-4 pt-5 pb-4 text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full sm:p-6 dark:bg-gray-800"
        :class="sizeClasses"
      >
        <!-- Modal header -->
        <div class="flex items-center justify-between mb-4">
          <h3 class="text-lg font-semibold text-gray-900 dark:text-white" id="modal-title">
            {{ title }}
          </h3>
          <button
            type="button"
            class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ml-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white"
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

        <!-- Modal footer -->
        <div v-if="showFooter" class="flex items-center justify-end space-x-3 mt-6 pt-4 border-t border-gray-200 dark:border-gray-600">
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
            <i v-if="saving" class="fas fa-spinner fa-spin mr-2"></i>
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
