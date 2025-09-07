<script setup lang="ts">
const { label, modelValue = false } = defineProps<{
  label?: string
  modelValue?: boolean
}>()

const emit = defineEmits(['update:modelValue'])

function handleInput(value: boolean) {
  emit('update:modelValue', value)
}
</script>

<template>
  <div class="flex items-center justify-between">
    <h3 class="mb-1 text-lg">
      {{ label }}
    </h3>
    <SwitchRoot
      id="airplane-mode"
      class="w-[33px] h-[20px] bg-purple-100 data-[state=checked]:bg-purple-700 relative"
      :model-value="modelValue"
      @update:model-value="handleInput"
    >
      <SwitchThumb
        class="w-3.5 h-3.5 bg-purple-700 data-[state=checked]:bg-purple-100 flex items-center justify-center transition-transform translate-x-1 data-[state=checked]:translate-x-4"
      />
    </SwitchRoot>
  </div>
</template>
