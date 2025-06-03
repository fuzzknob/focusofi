<script setup lang="ts">
import { useForm } from 'vee-validate'
import { toTypedSchema } from '@vee-validate/zod'
import zod from 'zod'

const isOpen = ref(false)

const settingStore = useSettingsStore()

const validationSchema = toTypedSchema(
  zod.object({
    workMinutes: zod.number().int().min(1).max(60),
    shortBreakMinutes: zod.number().int().min(1).max(60),
    longBreakMinutes: zod.number().int().min(1).max(60),
    breakSuccessions: zod.number().int().min(2).max(10),
  }),
)

const { defineField, handleSubmit, errors, meta, setValues } = useForm({
  initialValues: {
    workMinutes: settingStore.workLength / 60,
    shortBreakMinutes: settingStore.shortBreakLength / 60,
    longBreakMinutes: settingStore.longBreakLength / 60,
    breakSuccessions: settingStore.breakSuccessions,
  },
  validationSchema,
})

const [workMinutes, workMinutesProps] = defineField('workMinutes')
const [shortBreakMinutes, shortBreakMinutesProps] = defineField('shortBreakMinutes')
const [longBreakMinutes, longBreakMinutesProps] = defineField('longBreakMinutes')
const [breakSuccessions, breakSuccessionsProps] = defineField('breakSuccessions')

const isSubmitting = ref(false)

const timeFormatOption: Intl.NumberFormatOptions = {
  style: 'unit',
  unit: 'minute',
  unitDisplay: 'narrow',
}

watch(isOpen, () => {
  setValues({
    workMinutes: settingStore.workLength / 60,
    shortBreakMinutes: settingStore.shortBreakLength / 60,
    longBreakMinutes: settingStore.longBreakLength / 60,
    breakSuccessions: settingStore.breakSuccessions,
  })
})

const handleSettingsSubmit = handleSubmit(async (values) => {
  isSubmitting.value = true
  try {
    await settingStore.saveSettings({
      workLength: values.workMinutes * 60,
      longBreakLength: values.longBreakMinutes * 60,
      shortBreakLength: values.shortBreakMinutes * 60,
      breakSuccessions: values.breakSuccessions,
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
    <DialogTrigger class="flex">
      <Icon
        name="memory:dot-octagon"
        size="25"
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
              v-model="breakSuccessions"
              v-bind="breakSuccessionsProps"
              label="Break succession"
              :min="2"
              :max="10"
              :error="meta.touched ? errors.breakSuccessions : ''"
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
