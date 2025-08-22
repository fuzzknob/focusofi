import { defineStore, acceptHMRUpdate } from 'pinia'
import { differenceInSeconds, addSeconds, subSeconds } from 'date-fns'

import { useSettingsStore } from './settings'
import { TimerStatus } from '@/types/types'
import type { Fetch, Settings, Timer } from '@/types/types'
import { fetchTimer, startTimer, pauseTimer, resumeTimer, endBreak, stopTimer, resetTimer } from '~/services/timer'

export const useTimerStore = defineStore('timer', {
  state: () => ({
    time: 0,
    status: TimerStatus.Idle,
    previousStatus: TimerStatus.Idle,
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
            this.changeStatus(TimerStatus.LongBreak)
            this.successionCount = settings.breakSuccessions
          }
          else {
            this.changeStatus(TimerStatus.ShortBreak)
            this.successionCount -= 1
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
          this.changeStatus(TimerStatus.Working)

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
        const time = settings.workLength - this.elapsedPrePause
        this.time = time < 0 ? 0 : time
        return
      }

      this.time = differenceInSeconds(
        addSeconds(startTime, length),
        new Date(),
      )
    },

    changeStatus(status: TimerStatus) {
      this.previousStatus = this.status
      this.status = status
    },

    async reset(option?: { noSend: boolean }) {
      this.time = 0
      this.status = TimerStatus.Idle
      this.previousStatus = TimerStatus.Idle
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

      this.changeStatus(TimerStatus.Working)

      this.successionCount = settings.breakSuccessions
      this.startTime = new Date()
      this.time = settings.workLength

      const user = useUser()

      if (user.value) {
        await startTimer(this.startTime)
      }
    },

    async stop() {
      this.changeStatus(TimerStatus.Stopped)

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

      this.changeStatus(TimerStatus.Paused)

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
      const settings = useSettingsStore()

      this.startTime = settings.workLength < this.elapsedPrePause
        ? subSeconds(new Date(), settings.workLength)
        : subSeconds(new Date(), this.elapsedPrePause)

      this.elapsedPrePause = 0

      this.changeStatus(TimerStatus.Working)

      const user = useUser()

      if (user.value) {
        await resumeTimer(this.startTime)
      }
    },

    async endBreak() {
      const { successionCount } = this

      this.changeStatus(TimerStatus.Working)

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
      this.previousStatus = TimerStatus.Idle
      this.successionCount = timer.successionCount
      this.startTime = timer.startTime
      this.elapsedPrePause = timer.elapsedPrePause
      this.report = {
        totalWorked: timer.totalWorkTime,
        totalBreakTaken: timer.totalBreakTime,
      }

      this.calculateTime()
    },

    getCurrentStatusLength() {
      const settings = useSettingsStore()

      if (this.status === TimerStatus.Working) {
        return settings.workLength
      }
      if (this.status === TimerStatus.ShortBreak) {
        return settings.shortBreakLength
      }
      if (this.status === TimerStatus.LongBreak) {
        return settings.longBreakLength
      }

      return null
    },

    adjustTimerToSettings(settings: Settings) {
      const oldSettings = useSettingsStore()

      const { status, startTime } = this

      if (![
        TimerStatus.Working,
        TimerStatus.LongBreak,
        TimerStatus.ShortBreak,
        TimerStatus.Paused,
      ].includes(status)) {
        return
      }

      const now = new Date()
      const timePassed = differenceInSeconds(now, startTime!)

      if (settings.breakSuccessions != oldSettings.breakSuccessions) {
        const index = oldSettings.breakSuccessions - this.successionCount
        this.successionCount = settings.breakSuccessions - index
      }

      if (this.successionCount <= 0) {
        this.successionCount = settings.breakSuccessions

        if ([TimerStatus.ShortBreak, TimerStatus.LongBreak].includes(this.status)) {
          this.report.totalBreakTaken += timePassed
        }
        else {
          this.report.totalWorked += timePassed
        }

        if (this.status === TimerStatus.Paused) {
          this.elapsedPrePause = 0
          return
        }

        this.startTime = now

        this.status = TimerStatus.Working

        return
      }

      if (this.status === TimerStatus.Paused) {
        return
      }

      const statusLength = this.getCurrentStatusLength()

      if (statusLength == null) return

      const timerCount = statusLength - timePassed

      if (timerCount >= 0) {
        return
      }

      this.startTime = now

      if ([TimerStatus.ShortBreak, TimerStatus.LongBreak].includes(this.status)) {
        this.status = TimerStatus.Working
        this.report.totalBreakTaken += timePassed

        return
      }

      if (this.successionCount <= 1) {
        this.status = TimerStatus.LongBreak
        this.successionCount = settings.breakSuccessions
      }
      else {
        this.status = TimerStatus.ShortBreak
        this.successionCount -= 1
      }

      this.report.totalWorked += timePassed
    },
  },
})

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useTimerStore, import.meta.hot))
}
