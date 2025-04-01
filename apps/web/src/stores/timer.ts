import { defineStore, acceptHMRUpdate } from 'pinia'
import { differenceInSeconds, addSeconds, subSeconds, isEqual } from 'date-fns'

import { useSettingsStore } from './settings'
import { TimerStatus } from '@/types/types'
import type { Fetch, Timer } from '@/types/types'
import { notifyLongBreak, notifyShortBreak, notifyWorkStart } from '@/services/notification'
import { fetchTimer, startTimer, pauseTimer, resumeTimer, endBreak, stopTimer, resetTimer } from '~/services/timer'

export const useTimerStore = defineStore('timer', {
  state: () => ({
    time: 0,
    status: TimerStatus.Idle,
    successionCount: 0,
    startTime: null as Date | null,
    elapsedPrePause: 0,
    report: {
      totalWorked: 0,
      totalBreakTaken: 0,
    },
  }),
  actions: {
    tick() {
      const { status, time, successionCount, startTime } = this
      if (startTime == null) return
      const settings = useSettingsStore()
      if (status === TimerStatus.Working) {
        if (time <= 0) {
          if (successionCount <= 1) {
            this.status = TimerStatus.LongBreak
            this.successionCount = settings.breakSuccessions
            notifyLongBreak()
          }
          else {
            this.status = TimerStatus.ShortBreak
            this.successionCount -= 1
            notifyShortBreak()
          }
          this.startTime = addSeconds(startTime, settings.workLength)
          this.calculateTime()
          return
        }
        this.calculateTime()
        this.report.totalWorked += 1
        return
      }
      if (status === TimerStatus.LongBreak || status === TimerStatus.ShortBreak) {
        if (time <= 0) {
          this.status = TimerStatus.Working
          notifyWorkStart()
          this.startTime = addSeconds(
            startTime, status === TimerStatus.LongBreak ? settings.longBreakLength : settings.shortBreakLength,
          )
          this.calculateTime()
          return
        }
        this.calculateTime()
        this.report.totalBreakTaken += 1
        return
      }
    },
    calculateTime() {
      const { status, startTime } = this
      const settings = useSettingsStore()
      if (!startTime) {
        this.time = 0
        return
      }
      let length = 0
      if (status === TimerStatus.Working) {
        length = settings.workLength
      }
      if (status === TimerStatus.LongBreak) {
        length = settings.longBreakLength
      }
      if (status === TimerStatus.ShortBreak) {
        length = settings.shortBreakLength
      }
      if (status === TimerStatus.Paused) {
        this.time = settings.workLength - this.elapsedPrePause
        return
      }
      this.time = differenceInSeconds(
        addSeconds(startTime, length),
        new Date(),
      )
    },
    async reset(option?: { noSend: boolean }) {
      this.time = 0
      this.status = TimerStatus.Idle
      this.successionCount = 0
      this.startTime = null
      this.elapsedPrePause = 0
      this.report = {
        totalWorked: 0,
        totalBreakTaken: 0,
      }
      const user = useUser()
      if (user.value && !(option && option.noSend)) {
        await resetTimer()
      }
    },
    async start() {
      const settings = useSettingsStore()
      this.status = TimerStatus.Working
      this.successionCount = settings.breakSuccessions
      this.startTime = new Date()
      this.time = settings.workLength
      const user = useUser()
      if (user.value) {
        await startTimer(this.startTime)
      }
    },
    async stop() {
      this.status = TimerStatus.Stopped
      const user = useUser()
      if (user.value) {
        const { report } = this
        await stopTimer({
          endTime: new Date(),
          totalBreakTime: report.totalBreakTaken,
          totalWorkTime: report.totalWorked,
        })
      }
    },
    async pause() {
      const settings = useSettingsStore()
      this.status = TimerStatus.Paused
      this.elapsedPrePause = settings.workLength - this.time
      const user = useUser()
      if (user.value) {
        await pauseTimer({
          elapsedPrePause: this.elapsedPrePause,
          successionCount: this.successionCount,
          totalWorkTime: this.report.totalWorked,
          totalBreakTime: this.report.totalBreakTaken,
        })
      }
    },
    async resume() {
      this.startTime = subSeconds(new Date(), this.elapsedPrePause)
      this.elapsedPrePause = 0
      this.status = TimerStatus.Working
      const user = useUser()
      if (user.value) {
        await resumeTimer(this.startTime)
      }
    },
    async endBreak() {
      // const settings = useSettingsStore()
      const { successionCount } = this
      this.status = TimerStatus.Working
      this.startTime = new Date()
      this.calculateTime()
      const user = useUser()
      if (user.value) {
        const { report } = this
        await endBreak({
          startTime: this.startTime,
          successionCount: successionCount,
          totalBreakTime: report.totalBreakTaken,
          totalWorkTime: report.totalWorked,
        })
      }
    },
    async getTimer(fetch: Fetch) {
      const timer = await fetchTimer(fetch)
      if (!timer) return
      this.setTimer(timer)
    },

    setTimer(timer: Timer) {
      this.status = timer.status
      this.successionCount = timer.successionCount
      this.startTime = timer.startTime
      this.elapsedPrePause = timer.elapsedPrePause
      this.report = {
        totalWorked: timer.totalWorkTime,
        totalBreakTaken: timer.totalBreakTime,
      }
      this.calculateTime()
    },
  },
})

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useTimerStore, import.meta.hot))
}
