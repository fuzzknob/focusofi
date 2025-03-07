export function getRandomString(size = 32) {
  if (size > 32) {
    throw new Error('size cannot be greater than 32')
  }
  const uuid = crypto.randomUUID().replaceAll('-', '')
  return uuid.substring(0, size)
}
