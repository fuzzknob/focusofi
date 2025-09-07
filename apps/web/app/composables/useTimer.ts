import { differenceInMilliseconds, getMilliseconds, subSeconds, addSeconds } from 'date-fns'

import { useSettings } from './useSettings'
import { useTimerServer } from './useTimerServer'
import { useNotification } from './useNotification'
import { BlockType, TimerState, Action } from '@/types'
import type { Block, Settings, Sequence, SSEEvent } from '@/types'

export const useTimer = () => {
  const timerServer = useTimerServer()
  const { notify } = useNotification()

  const sequence = useState<Sequence>('sequence', () => ({
    modified: false,
    blocks: [],
  }))
  const currentBlock = useState<Block | null>('current-block', () => null)
  const timerState = useState<TimerState>('timer-state', () => TimerState.idle)
  const blockIndex = useState<number>('block-index', () => -1)
  const accumulatedBreak = useState<number>('accumulated-break', () => 0)
  const accumulatedWork = useState<number>('accumulated-work', () => 0)
  const seqGenCount = useState<number>('seq-gen-count', () => 1)

  const timeout = useState<NodeJS.Timeout | number | null>('timer-timeout', () => null)
  const expectedTimeout = useState<number | null>('timer-expected-timeout', () => null)

  const user = useUser()

  const { settings } = useSettings()

  const time = computed(() => {
    if (currentBlock.value == null) return 0

    const { elapsed, length } = currentBlock.value
    const time = length - elapsed

    if (time < 0) return 0

    return time
  })

  // Public
  async function startTimer() {
    timerState.value = TimerState.running

    const startDate = new Date()

    getCurrentBlock(startDate)

    timerTick()

    if (user.value) {
      await timerServer.startTimer(startDate)
    }
  }

  async function pauseTimer() {
    if (timerState.value !== TimerState.running) return

    clearTimer()

    timerState.value = TimerState.paused

    const pauseTime = new Date()

    // last tick before pause
    stateTick(pauseTime)

    if (user.value) {
      await timerServer.pauseTimer(pauseTime)
    }
  }

  async function resumeTimer() {
    if (timerState.value !== TimerState.paused) return

    const block = currentBlock.value!

    const resumeTime = new Date()

    block.startTime = subSeconds(resumeTime, block.elapsed)

    timerState.value = TimerState.running
    timerTick()

    if (user.value) {
      await timerServer.resumeTimer(resumeTime)
    }
  }

  async function stopTimer() {
    clearTimer()

    const stopTime = new Date()

    // last tick before stopping
    if (timerState.value === TimerState.running) {
      stateTick(stopTime)
    }

    timerState.value = TimerState.stopped

    if (user.value) {
      await timerServer.stopTimer(stopTime)
    }
  }

  async function resetTimer(sendToServer = true) {
    timerState.value = TimerState.idle
    currentBlock.value = null
    blockIndex.value = -1
    expectedTimeout.value = null
    timeout.value = null
    seqGenCount.value = 1
    accumulatedWork.value = 0
    accumulatedBreak.value = 0
    sequence.value = {
      modified: false,
      blocks: [],
    }

    getNewSequence()

    if (user.value && sendToServer) {
      await timerServer.resetTimer()
    }
  }

  async function skipBlock() {
    const startTime = new Date()

    clearTimer()

    stateTick(startTime)

    const block = currentBlock.value

    if (block) {
      block.completed = true
    }

    getCurrentBlock(startTime)

    timerState.value = TimerState.running

    timerTick()

    if (user.value) {
      await timerServer.skipTimer(startTime)
    }
  }

  async function initTimerServer() {
    getNewSequence()

    if (!user.value) {
      return
    }

    const timer = await timerServer.fetchTimer()

    if (timer == null) {
      return
    }

    sequence.value = timer.currentSequence
    timerState.value = timer.timerState
    accumulatedBreak.value = timer.accumulatedBreak
    accumulatedWork.value = timer.accumulatedWork
    seqGenCount.value = timer.seqGenCount

    getCurrentBlock()
  }

  function initTimerClient() {
    if (timerState.value !== TimerState.running) {
      return
    }

    const now = new Date()

    const start = getMilliseconds(currentBlock.value!.startTime!)
    const current = now.getMilliseconds()
    const interval = start > current ? start - current : 1000 - current + start

    expectedTimeout.value = now.getTime() + interval
    timeout.value = setTimeout(timerTick, interval)

    if (!user.value) {
      return
    }
  }

  // Private
  function timerTick() {
    const now = new Date()

    stateTick(now)

    const interval = 1000
    let slippage = 0

    if (expectedTimeout.value) {
      slippage = now.getTime() - expectedTimeout.value
      expectedTimeout.value += interval
    }
    else {
      expectedTimeout.value = currentBlock.value!.startTime!.getTime() + interval
    }

    timeout.value = setTimeout(timerTick, interval - slippage)
  }

  function stateTick(now: Date) {
    const block = currentBlock.value
    if (block == null) return

    const startTime = block.startTime!

    // Using ms solves the countdown glitch issue
    const elapsedMs = differenceInMilliseconds(now, startTime)

    const elapsed = Math.round(elapsedMs / 1000)

    if (elapsed >= block.length) {
      block.elapsed = block.length
      block.completed = true

      getCurrentBlock(addSeconds(startTime, block.length))

      notify(currentBlock.value!.type)

      return
    }

    block.elapsed = elapsed
  }

  function getCurrentBlock(startDate?: Date) {
    const blocks = sequence.value.blocks

    for (const index in blocks) {
      const block = blocks[index]!

      if (block.completed) {
        continue
      }

      if (block.startTime == null) {
        block.startTime = startDate ?? new Date()
      }

      currentBlock.value = block
      blockIndex.value = parseInt(index)

      if (blockIndex.value == 0) {
        sequence.value.startTime = block.startTime
      }

      return
    }

    getNewSequence()
    getCurrentBlock(startDate)
  }

  function getNewSequence() {
    const { blocks } = sequence.value

    if (timerState.value !== TimerState.idle) {
      accumulatedBreak.value += blocks
        .filter(block => [BlockType.shortBreak, BlockType.longBreak].includes(block.type))
        .reduce((previous, block) => previous + block.elapsed, 0)
      accumulatedWork.value += blocks
        .filter(block => block.type === BlockType.work)
        .reduce((previous, block) => previous + block.elapsed, 0)

      seqGenCount.value++
    }

    if (settings.value.progressive && seqGenCount.value <= 1) {
      // progressive sequence
      sequence.value = {
        blocks: [
          { type: BlockType.work, length: 300, completed: false, elapsed: 0 },
          { type: BlockType.shortBreak, length: 300, completed: false, elapsed: 0 },
          { type: BlockType.work, length: 600, completed: false, elapsed: 0 },
          { type: BlockType.shortBreak, length: 300, completed: false, elapsed: 0 },
          { type: BlockType.work, length: 900, completed: false, elapsed: 0 },
          { type: BlockType.shortBreak, length: 300, completed: false, elapsed: 0 },
          { type: BlockType.work, length: 1200, completed: false, elapsed: 0 },
          { type: BlockType.shortBreak, length: 300, completed: false, elapsed: 0 },
          { type: BlockType.work, length: 1500, completed: false, elapsed: 0 },
          { type: BlockType.longBreak, length: 900, completed: false, elapsed: 0 },
        ],
        modified: true,
      }
    }
    else {
      sequence.value = generateSequence(settings.value!)
    }
  }

  function clearTimer() {
    if (!timeout.value) return

    clearTimeout(timeout.value)
    expectedTimeout.value = null
  }

  // TODO: revamp this function
  function adjustTimerToSettings() {
    getNewSequence()
    // const newSequence = generateSequence(settings.value!)
    // const current = currentBlock.value

    // if (current == null) {
    //   sequence.value = newSequence
    //   return
    // }

    // let newIndex = 0

    // if ((blockIndex.value + 1) < newSequence.blocks.length) {
    //   newIndex = blockIndex.value
    // }

    // const block = newSequence.blocks[newIndex]!
    // block.startTime = current.startTime
    // currentBlock.value = block
    // stateTick(new Date())
  }

  function syncWithEvent(event: SSEEvent) {
    const { action, timer } = event

    clearTimer()

    if (action === Action.reset) {
      resetTimer(false)
      return
    }

    sequence.value = timer.currentSequence
    timerState.value = timer.timerState
    accumulatedBreak.value = timer.accumulatedBreak
    accumulatedWork.value = timer.accumulatedWork
    seqGenCount.value = timer.seqGenCount

    getCurrentBlock()

    initTimerClient()
  }

  return {
    // states
    sequence,
    currentBlock,
    blockIndex,
    timerState,
    accumulatedBreak,
    accumulatedWork,

    // computed
    time,

    // actions
    startTimer,
    pauseTimer,
    resumeTimer,
    stopTimer,
    resetTimer,
    skipBlock,
    syncWithEvent,
    // extendBlock,

    initTimerServer,
    initTimerClient,
    adjustTimerToSettings,
  }
}

function generateSequence(settings: Settings, startTime?: Date) {
  const { workSessions, workLength, longBreakLength, shortBreakLength } = settings

  const blocks: Block[] = []

  for (let i = 1; i <= workSessions; i++) {
    blocks.push({
      type: BlockType.work,
      length: workLength,
      elapsed: 0,
      completed: false,
    })

    if (i < workSessions) {
      blocks.push({
        type: BlockType.shortBreak,
        length: shortBreakLength,
        elapsed: 0,
        completed: false,
      })
      continue
    }

    blocks.push({
      type: BlockType.longBreak,
      length: longBreakLength,
      elapsed: 0,
      completed: false,
    })
  }

  return {
    startTime,
    blocks,
    modified: false,
  } as Sequence
}
