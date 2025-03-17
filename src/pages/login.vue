<script setup lang="ts">
import { useForm } from 'vee-validate'
import { toTypedSchema } from '@vee-validate/zod'
import zod from 'zod'

import Background from '@/sections/Background.vue'
import Button from '@/components/ButtonSquare.vue'
import Input from '@/components/Input.vue'

const validationSchema = toTypedSchema(
  zod.object({
    email: zod.string().email(),
  }),
)
const { defineField, handleSubmit, errors, meta } = useForm({
  validationSchema,
})
const [email, emailProps] = defineField('email')
const isLoading = ref(false)
const errorMessage = ref('')
const hasEmailSubmitted = ref(false)
const otpCode = ref('')

useHead({
  title: 'Login - Pomo',
})

const handleRequestLogin = handleSubmit(async (values) => {
  isLoading.value = true
  try {
    await $fetch('/api/auth/request-login', {
      method: 'POST',
      body: {
        email: values.email,
      },
    })
    hasEmailSubmitted.value = true
  }
  catch {
    errorMessage.value = 'There was an error while submitting email'
  }
  finally {
    isLoading.value = false
    errorMessage.value = ''
  }
})

async function handleOtpSubmit() {
  isLoading.value = true
  try {
    await $fetch('/api/auth/login-with-otp', {
      method: 'POST',
      body: {
        otp: otpCode.value,
      },
    })
    reloadNuxtApp()
  }
  catch {
    errorMessage.value = 'There was an error while submitting email'
    isLoading.value = false
  }
}
</script>

<template>
  <main class="w-screen h-screen flex-center">
    <Background />
    <div
      class="absolute px-6 py-8 bg-purple-200 w-[400px]"
    >
      <form
        v-if="hasEmailSubmitted"
        @submit.prevent="handleOtpSubmit"
      >
        <h4
          class="text-xl mb-2"
        >
          We've sent you a code on your email. Please check your inbox and enter the code below
        </h4>
        <div class="flex flex-col">
          <Input
            v-model="otpCode"
            class="mb-2"
            placeholder="ENTER CODE"
          />
          <Button
            type="submit"
            class="text-xl mt-2"
            :disabled="isLoading || !otpCode"
          >
            {{ isLoading ? 'SUBMITTING...' : 'SUBMIT' }}
          </Button>
        </div>
      </form>
      <form
        v-else
        @submit.prevent="handleRequestLogin"
      >
        <h3 class="text-4xl mb-2">
          Login
        </h3>
        <div class="flex flex-col gap-2 mb-2">
          <Input
            v-model="email"
            v-bind="emailProps"
            label="Email"
            :error="meta.touched ? errors.email : ''"
            placeholder="you@example.com"
          />
          <Button
            type="submit"
            class="text-xl mt-2"
            :disabled="isLoading"
          >
            {{ isLoading ? 'REQUESTING...' : 'REQUEST LOGIN' }}
          </Button>
          <p
            v-if="errorMessage"
            class="text-red-500"
          >
            {{ errorMessage }}
          </p>
        </div>
      </form>
    </div>
  </main>
</template>
