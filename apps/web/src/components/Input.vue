<script setup lang="ts">
import type { InputTypeHTMLAttribute } from 'vue'

const { label, type = 'text', modelValue, error } = defineProps<{
  label?: string
  type?: InputTypeHTMLAttribute
  placeholder?: string
  modelValue?: string
  error?: string
}>()
const emit = defineEmits(['update:modelValue'])

function handleInput(event: Event) {
  const targetElement = event.target as HTMLInputElement
  emit('update:modelValue', targetElement?.value)
}
</script>

<template>
  <label class="flex flex-col w-full">
    <h5>{{ label }}</h5>
    <input
      class="w-full px-2 py-1 text-gray-600 bg-purple-100 focus:bg-purple-50 outline-none"
      :class="{ 'bg-red-300': !!error }"
      :value="modelValue"
      :placeholder="placeholder"
      :type="type"
      @input="handleInput"
    >
    <span
      v-if="error"
      class="text-sm text-red-500"
    >{{ error }}</span>
  </label>
</template>
