import type { H3Event$Fetch } from 'nitropack/types'

export enum TimerStatus {
  Idle = 'IDLE',
  Working = 'WORKING',
  ShortBreak = 'SHORT_BREAK',
  LongBreak = 'LONG_BREAK',
  Paused = 'PAUSED',
  Stopped = 'STOPPED',
}

export interface Timer {
  startTime: Date
  status: TimerStatus
  successionCount: number
  elapsedPrePause: number
  totalWorkTime: number
  totalBreakTime: number
}

export interface Background {
  id: number
  img: string
}

export type Fetch = H3Event$Fetch | typeof global.$fetch

export interface Settings {
  workLength: number
  shortBreakLength: number
  longBreakLength: number
  breakSuccessions: number
}

export interface User {
  id: number
  email: string
  role: 'USER' | 'ADMIN'
}

export interface Session {
  token: string
  expiration: Date
  user: User
}
