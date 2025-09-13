<script lang="ts" setup>
import { formatSecondsToTime } from '@/libs/utils'

import { TimerState, BlockType } from '@/types'

const { time, sequence, blockIndex, timerState, currentBlock } = useTimer()

const minutesHand = ref(['O', 'O'])
const secondsHand = ref(['O', 'O'])

const separatorVisible = computed(() => {
  return time.value % 2 === 0
})

const textColor = computed(() => {
  if (timerState.value === TimerState.paused) {
    return 'text-blue-500'
  }

  const blockType = currentBlock.value?.type

  if (blockType != null && [BlockType.shortBreak, BlockType.longBreak].includes(blockType)) {
    return 'text-green-300'
  }

  return 'text-white'
})

watch(time, () => {
  const { minutes, seconds } = formatSecondsToTime(time.value)

  minutesHand.value = minutes.toString().padStart(2, 'O').replaceAll('0', 'O').split('')
  secondsHand.value = seconds.toString().padStart(2, 'O').replaceAll('0', 'O').split('')
}, {
  immediate: true,
})
</script>

<template>
  <div>
    <div class="md:-mb-28 -mb-20 flex justify-center">
      <div class="flex items-end text-2xl">
        <template
          v-for="(block, index) in sequence.blocks"
          :key="index"
        >
          <div
            v-if="block.type === BlockType.work"
            class="h-8 w-9 border-4 border-r-0 border-white flex-center"
            :class="{ 'border-l-0': index > 0, 'bg-white text-black': index === blockIndex }"
          >
            W
          </div>
          <div
            v-else-if="block.type === BlockType.shortBreak"
            class="h-10 border-4 border-white flex items-end"
            :class="{ 'bg-white text-black': index === blockIndex }"
          >
            <div class="flex-center w-7 h-6">
              S
            </div>
          </div>
          <div
            v-else
            class="h-10 border-4 border-white flex items-end"
            :class="{ 'bg-white text-black': index === blockIndex }"
          >
            <div class="flex-center w-7 h-6">
              L
            </div>
          </div>
        </template>
      </div>
    </div>
    <div
      class="flex items-center text-[13rem] md:text-[19rem]"
      :class="textColor"
    >
      <div class="flex">
        <div class="w-[90px] md:w-[135px] text-end">
          {{ minutesHand[0] }}
        </div>
        <div class="w-[90px] md:w-[135px] text-end">
          {{ minutesHand[1] }}
        </div>
      </div>
      <div class="w-[50px] md:w-[60px] flex flex-center pb-4 pointer-events-none">
        <span :class="{ 'opacity-0': !separatorVisible }">:</span>
      </div>
      <div class="flex">
        <div class="w-[90px] md:w-[135px] text-end">
          {{ secondsHand[0] }}
        </div>
        <div class="w-[90px] md:w-[135px] text-end">
          {{ secondsHand[1] }}
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.separator {
  width: 60px;

  span {
    margin-bottom: 15px;
  }
}
</style>
