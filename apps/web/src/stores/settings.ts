import { defineStore, acceptHMRUpdate } from 'pinia'

import { useUser } from '@/composables/useUser'
import { getSettingsFromServer, getSettingsFromLocalStorage } from '@/services/settings'
import type { Settings, Fetch } from '~/types/types'

export const useSettingsStore = defineStore('settings', {
  state: () => ({
    workLength: 2400,
    shortBreakLength: 120,
    longBreakLength: 600,
    breakSuccessions: 4,
    hasFetched: false,
  }),
  actions: {
    async getSettings(fetch: Fetch) {
      const user = useUser()
      let settings: Settings | null = null
      if (user.value) {
        settings = await getSettingsFromServer(fetch)
      }
      else if (import.meta.client) {
        settings = getSettingsFromLocalStorage()
      }
      if (!settings) return
      this.workLength = settings.workLength
      this.shortBreakLength = settings.shortBreakLength
      this.longBreakLength = settings.longBreakLength
      this.breakSuccessions = settings.breakSuccessions
      this.hasFetched = true
      return settings
    },
  },
})

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useSettingsStore, import.meta.hot))
}
