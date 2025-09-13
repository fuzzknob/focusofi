<script setup lang="ts">
type Props = {
  label?: string
  modelValue?: number
  formatOptions?: Intl.NumberFormatOptions
  min?: number
  max?: number
  error?: string
}

const { label = '', modelValue = 0, error = '', min, max, formatOptions } = defineProps<Props>()

const emit = defineEmits(['update:modelValue'])

function handleInput(value: number) {
  emit('update:modelValue', value)
}
</script>

<template>
  <div class="flex flex-col">
    <h3 class="mb-1 text-lg">
      {{ label }}
    </h3>
    <div class="flex">
      <NumberFieldRoot
        class="flex items-center gap-2 h-[30px] px-2 bg-purple-100"
        :min="min"
        :max="max"
        :default-value="18"
        :model-value="modelValue"
        :format-options="formatOptions"
        @update:model-value="handleInput"
      >
        <NumberFieldDecrement class="text-2xl">
          -
        </NumberFieldDecrement>
        <NumberFieldInput
          class="outline-0 text-center"
        />

        <NumberFieldIncrement class="text-2xl">
          +
        </NumberFieldIncrement>
      </NumberFieldRoot>
    </div>
    <span
      v-if="error"
      class="text-sm text-red-500"
    >{{ error }}</span>
  </div>
</template>
