import type { User } from '@/types'
import { useUser } from './useUser'

export const useAuth = () => {
  const { $api } = useNuxtApp()
  const user = useUser()

  async function getUser() {
    try {
      user.value = await $api<User>('/auth/me')
    }
    catch {
      user.value = null
    }
  }

  function requestLogin(email: string) {
    return $api('/auth/request-login', {
      method: 'POST',
      body: {
        email,
      },
    })
  }

  async function loginWithOtp(otp: string) {
    user.value = await $api<User>('/auth/login-with-otp', {
      method: 'POST',
      body: {
        otp,
      },
    })
  }

  return {
    getUser,
    requestLogin,
    loginWithOtp,
  }
}
