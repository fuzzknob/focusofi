import { TimerState } from '@/types'
import type { Settings } from '@/types'

const SETTINGS_KEY = 'settings'

export const useSettings = () => {
  const settings = useState<Settings>('settings', () => ({
    workLength: 2400,
    shortBreakLength: 120,
    longBreakLength: 600,
    workSessions: 3,
    progressive: false,
  }))
  const user = useUser()

  const { $api } = useNuxtApp()

  const isSettingsFetched = useState('isSettingsFetched', () => false)

  /// Public

  async function getSettings() {
    if (user.value != null) {
      await getSettingsFromServer()
    }
  }

  async function saveSettings(newSettings: Settings) {
    const timer = useTimer()

    // TODO: remove this check once adjust timer to settings is fully implemented
    if (timer.timerState.value !== TimerState.idle) {
      return
    }

    const user = useUser()

    if (user.value != null) {
      await storeSettingsToServer(newSettings)
    }
    else {
      storeSettingsInLocalStorage(newSettings)
    }

    settings.value = newSettings

    timer.adjustTimerToSettings()
  }

  /// Private

  async function storeSettingsToServer(newSettings: Settings) {
    await $api('/settings', {
      method: 'PUT',
      body: newSettings,
    })
  }

  async function storeSettingsInLocalStorage(newSettings: Settings) {
    localStorage.setItem(SETTINGS_KEY, JSON.stringify(newSettings))
  }

  async function getSettingsFromServer() {
    const fetched = await useNuxtApp().$api<Settings | undefined>('/settings')
    if (fetched == null) {
      return
    }

    settings.value = fetched
    isSettingsFetched.value = true
  }

  return {
    /// States
    settings,
    isSettingsFetched,

    /// Actions
    saveSettings,
    getSettings,
  }
}
