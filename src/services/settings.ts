import type { Settings } from '@/types/types'
import type { Fetch } from '~/types/types'

const SETTINGS_KEY = 'settings'
const DEFAULT_SETTINGS = {
  workLength: 2400,
  shortBreakLength: 120,
  longBreakLength: 600,
  breakSuccessions: 4,
}

export async function getSettingsFromServer(fetch: Fetch): Promise<Settings | null> {
  try {
    const data = await fetch<Settings>('/api/settings')
    return data
  }
  catch {
    // ignored
  }
  return null
}

export function getSettingsFromLocalStorage(): Settings {
  const settings = localStorage.getItem(SETTINGS_KEY)
  if (settings) {
    return JSON.parse(settings)
  }
  localStorage.setItem(SETTINGS_KEY, JSON.stringify(DEFAULT_SETTINGS))
  return DEFAULT_SETTINGS
}
