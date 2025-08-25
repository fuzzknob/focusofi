export enum BlockType {
  work = 'WORK',
  shortBreak = 'SHORT_BREAK',
  longBreak = 'LONG_BREAK',
}

export enum TimerState {
  idle = 'IDLE',
  running = 'RUNNING',
  paused = 'PAUSED',
  stopped = 'STOPPED',
}

export enum Action {
  start = 'START',
  stop = 'STOP',
  reset = 'RESET',
  pause = 'PAUSE',
  endBreak = 'END_BREAK',
  resume = 'RESUME',
}

export type Block = {
  startTime?: Date
  length: number
  type: BlockType
  completed: boolean
  elapsed: number
}

export type Sequence = {
  startTime?: Date
  modified: boolean
  blocks: Block[]
}

export type Timer = {
  id: number
  startedAt: Date
  timerState: TimerState
  currentSequence: Sequence
  seqGenCount: number
  accumulatedBreak: number
  accumulatedWork: number
}

export interface Settings {
  workLength: number
  shortBreakLength: number
  longBreakLength: number
  workSessions: number
}

export interface User {
  id: number
  email: string
  role: 'USER' | 'ADMIN'
}

export interface Background {
  id: number
  img: string
}

export interface SSEEvent {
  action: Action
  timer: Timer
}
