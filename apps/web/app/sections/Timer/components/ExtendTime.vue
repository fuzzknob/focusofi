<script setup lang="ts">
import { ref } from 'vue'
import { useForm } from 'vee-validate'
import { TimerState } from '~/types'

const { timerState, pauseTimer, resumeTimer, extendLength } = useTimer()

const isOpen = ref(false)
const didTriggerPause = ref(false)

const timeFormatOption: Intl.NumberFormatOptions = {
  style: 'unit',
  unit: 'minute',
  unitDisplay: 'narrow',
}

const { defineField, handleSubmit, errors, meta } = useForm({
  initialValues: {
    customValue: 15,
  },
})

const [customValue, customValueProps] = defineField('customValue')

function handleChange(length: number) {
  extendLength(length)
  isOpen.value = false
}

const handleFormSubmit = handleSubmit(async (values) => {
  handleChange(values.customValue * 60)
})

watch(isOpen, () => {
  if (isOpen.value && timerState.value !== TimerState.paused) {
    pauseTimer()
    didTriggerPause.value = true
  }
  else if (didTriggerPause.value) {
    resumeTimer()
    didTriggerPause.value = false
  }
})
</script>

<template>
  <DialogRoot v-model:open="isOpen">
    <DialogTrigger
      title="Extend Time"
      class="flex hover:scale-110"
    >
      <Icon
        name="ion:md-timer"
        size="40"
      />
    </DialogTrigger>
    <DialogPortal>
      <DialogOverlay class="bg-black/70 fixed inset-0 z-10" />
      <DialogContent class="fixed top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 bg-purple-200 z-20">
        <div class="flex justify-between items-center px-5 pt-4">
          <DialogTitle class="text-2xl">
            Extend time
          </DialogTitle>
          <DialogClose class="text-2xl">
            x
          </DialogClose>
        </div>
        <div
          class="px-5 pt-2 pb-6"
        >
          <div class="flex justify-around my-2 text-xl gap-4">
            <Button
              class="w-full"
              title="Extend by 1 minutes"
              @click="() => handleChange(60)"
            >
              1 m
            </Button>
            <Button
              class="w-full"
              title="Extend by 5 minutes"
              @click="() => handleChange(300)"
            >
              5 m
            </Button>
            <Button
              class="w-full"
              title="Extend by 5 minutes"
              @click="() => handleChange(600)"
            >
              10 m
            </Button>
          </div>

          <h3 class="text-xl">
            Custom:
          </h3>
          <form
            class="flex gap-4 items-center"
            @submit.prevent="handleFormSubmit"
          >
            <NumberInput
              v-model="customValue"
              v-bind="customValueProps"
              class="h-[40px]"
              :max="60"
              :min="1"
              :format-options="timeFormatOption"
              :error="meta.touched ? errors.customValue : ''"
            />
            <Button
              type="submit"
              :title="`Extend by ${customValue} minutes`"
            >
              EXTEND
            </Button>
          </form>
        </div>
      </DialogContent>
    </DialogPortal>
  </DialogRoot>
</template>
