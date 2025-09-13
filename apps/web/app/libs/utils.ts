export function formatSecondsToTime(s: number) {
  let seconds = s
  let hours = 0
  let minutes = 0
  if (seconds >= 3600) {
    hours = Math.floor(seconds / 3600)
    seconds -= hours * 3600
  }
  if (seconds >= 60) {
    minutes = Math.floor(seconds / 60)
    seconds -= minutes * 60
  }
  return {
    hours,
    minutes,
    seconds,
  }
}

export type Time = {
  hours: number
  minutes: number
  seconds: number
}

export function timeToText(time: Time, short = false) {
  if (short) {
    type Key = keyof Time
    const keys: Key[] = ['hours', 'minutes', 'seconds']
    return keys
      .filter(entity => time[entity])
      .map(entity => `${time[entity]}${entity.substring(0, 1)}`)
      .join(' ')
  }
  const { hours, minutes, seconds } = time
  const timeEntities = []
  if (hours) {
    // timeEntities.push(`${hours} ${hours > 1 ? 'hours' : 'hour'}`)
    timeEntities.push(`${hours}h`)
  }
  if (minutes) {
    timeEntities.push(`${minutes}m`)
  }
  if (seconds) {
    timeEntities.push(`${seconds}s`)
  }
  if (timeEntities.length === 0) {
    return '0s'
  }
  if (timeEntities.length === 1) {
    return timeEntities[0]
  }
  return timeEntities.map((entity) => {
    // if (index === (timeEntities.length - 1)) {
    //   return `and ${entity}`
    // }
    return entity
  }).join(' ')
}
