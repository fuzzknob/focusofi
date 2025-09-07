<script setup lang="ts">
import { ref, watch } from 'vue'
import { useForm } from 'vee-validate'
import { toTypedSchema } from '@vee-validate/zod'
import zod from 'zod'
import { TimerState } from '~/types'

const isOpen = ref(false)

const { timerState } = useTimer()
const { settings, saveSettings } = useSettings()

const validationSchema = toTypedSchema(
  zod.object({
    workMinutes: zod.number().int().min(1).max(60),
    shortBreakMinutes: zod.number().int().min(1).max(60),
    longBreakMinutes: zod.number().int().min(1).max(60),
    workSessions: zod.number().int().min(2).max(10),
    progresive: zod.boolean(),
  }),
)

const { defineField, setValues, handleSubmit, errors, meta } = useForm({
  initialValues: {
    workMinutes: settings.value!.workLength / 60,
    shortBreakMinutes: settings.value!.shortBreakLength / 60,
    longBreakMinutes: settings.value!.longBreakLength / 60,
    workSessions: settings.value!.workSessions,
    progresive: settings.value!.progressive,
  },
  validationSchema,
})

const [workMinutes, workMinutesProps] = defineField('workMinutes')
const [shortBreakMinutes, shortBreakMinutesProps] = defineField('shortBreakMinutes')
const [longBreakMinutes, longBreakMinutesProps] = defineField('longBreakMinutes')
const [workSessions, workSessionsProps] = defineField('workSessions')
const [progressive, progressiveProps] = defineField('progresive')

const isSubmitting = ref(false)

const timeFormatOption: Intl.NumberFormatOptions = {
  style: 'unit',
  unit: 'minute',
  unitDisplay: 'narrow',
}

watch(isOpen, () => {
  setValues({
    workMinutes: settings.value!.workLength / 60,
    shortBreakMinutes: settings.value!.shortBreakLength / 60,
    longBreakMinutes: settings.value!.longBreakLength / 60,
    workSessions: settings.value!.workSessions,
    progresive: settings.value!.progressive,
  })
})

const isTimerRunning = computed(() =>
  timerState.value !== TimerState.idle,
)

const handleSettingsSubmit = handleSubmit(async (values) => {
  isSubmitting.value = true
  try {
    await saveSettings({
      workLength: values.workMinutes * 60,
      longBreakLength: values.longBreakMinutes * 60,
      shortBreakLength: values.shortBreakMinutes * 60,
      workSessions: values.workSessions,
      progressive: values.progresive,
    })
    isOpen.value = false
  }
  catch {
    //
  }
  finally {
    isSubmitting.value = false
  }
})
</script>

<template>
  <DialogRoot v-model:open="isOpen">
    <DialogTrigger
      title="Settings"
      class="flex"
      :disabled="isTimerRunning"
    >
      <Icon
        name="ion:md-settings"
        :class="{ 'text-gray-400': isTimerRunning }"
        size="27"
      />
    </DialogTrigger>
    <DialogPortal>
      <DialogOverlay class="bg-black/70 fixed inset-0 z-10" />
      <DialogContent class="fixed top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 bg-purple-200 z-20">
        <div class="flex justify-between items-center px-5 pt-4">
          <DialogTitle class="text-2xl">
            Settings
          </DialogTitle>
          <DialogClose class="text-2xl">
            x
          </DialogClose>
        </div>
        <DialogDescription class="px-5 hidden">
          Change focusofi settings
        </DialogDescription>

        <form
          class="px-5 pt-2 pb-6"
          @submit.prevent="handleSettingsSubmit"
        >
          <div class="flex flex-col gap-3 mb-6">
            <NumberInput
              v-model="workMinutes"
              v-bind="workMinutesProps"
              label="Work Length"
              :max="60"
              :min="1"
              :format-options="timeFormatOption"
              :error="meta.touched ? errors.workMinutes : ''"
            />
            <NumberInput
              v-model="shortBreakMinutes"
              v-bind="shortBreakMinutesProps"
              label="Short break length"
              :max="60"
              :min="1"
              :format-options="timeFormatOption"
              :error="meta.touched ? errors.shortBreakMinutes : ''"
            />
            <NumberInput
              v-model="longBreakMinutes"
              v-bind="longBreakMinutesProps"
              label="Long break length"
              :max="60"
              :min="1"
              :format-options="timeFormatOption"
              :error="meta.touched ? errors.longBreakMinutes : ''"
            />
            <NumberInput
              v-model="workSessions"
              v-bind="workSessionsProps"
              label="Work Sessions"
              :min="2"
              :max="10"
              :error="meta.touched ? errors.workSessions : ''"
            />
            <Switch
              v-model="progressive"
              v-bind="progressiveProps"
              title="Experimental: Progressivly increases work time"
              label="Progressive:"
            />
          </div>
          <div class="flex-center">
            <Button type="submit">
              {{ isSubmitting ? 'Saving...' : 'Save' }}
            </Button>
          </div>
        </form>
      </DialogContent>
    </DialogPortal>
  </DialogRoot>
</template>
