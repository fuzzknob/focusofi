import { defineStore, acceptHMRUpdate } from 'pinia'

import {
  fetchSettingsFromServer,
  fetchSettingsFromLocalStorage,
  storeSettingsInServer,
  storeSettingsInLocalStorage,
} from '@/services/settings'
import { useUser } from '@/composables/useUser'
import { useTimerStore } from '@/stores/timer'
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
        settings = await fetchSettingsFromServer(fetch)
      }
      else if (import.meta.client) {
        settings = fetchSettingsFromLocalStorage()
      }

      if (!settings) return

      this.setSettings(settings)
      this.hasFetched = true

      return settings
    },

    async saveSettings(settings: Settings) {
      const user = useUser()

      if (user.value != null) {
        await storeSettingsInServer(settings)
      }
      else {
        await storeSettingsInLocalStorage(settings)
      }

      const timer = useTimerStore()

      timer.adjustTimerToSettings(settings)

      this.setSettings(settings)

      timer.calculateTime()
    },

    setSettings(settings: Settings) {
      this.workLength = settings.workLength
      this.shortBreakLength = settings.shortBreakLength
      this.longBreakLength = settings.longBreakLength
      this.breakSuccessions = settings.breakSuccessions
    },
  },
})

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useSettingsStore, import.meta.hot))
}
