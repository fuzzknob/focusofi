import { z } from 'zod'
import { addYears, isAfter } from 'date-fns'

import { getRandomString } from '~/server/libs/utils'
import { eq, tables, useDrizzle } from '~/server/services/drizzle'
import { useSecureSession } from '~/server/libs/secure_session'

const loginWithOtpSchema = z.object({
  otp: z.string().length(5),
})

export default defineEventHandler(async (event) => {
  const result = await readValidatedBody(event, loginWithOtpSchema.safeParse)
  if (!result.success) {
    setResponseStatus(event, 400)
    return { message: 'There was an validation error', errors: result.error.issues }
  }
  const db = useDrizzle()
  const { otp } = result.data
  const emailOtp = await db.delete(tables.emailOtps).where(eq(tables.emailOtps.otpCode, otp)).returning().get()
  if (!emailOtp || isAfter(new Date(), emailOtp.expiration)) {
    setResponseStatus(event, 400)
    return { message: 'Invalid otp code' }
  }
  const user = await db.query.users.findFirst({
    where: (users, { eq }) => eq(users.id, emailOtp.userId),
  })
  if (!user) {
    setResponseStatus(event, 500)
    return { message: 'Data inconsistency' }
  }
  if (!user.hasVerified) {
    await db.insert(tables.settings).values({
      userId: user.id,
    })
    await db.update(tables.users).set({
      hasVerified: true,
    })
  }
  const token = getRandomString(30)
  await db.insert(tables.sessions).values({
    token,
    expiration: addYears(new Date(), 1),
    userId: user.id,
  })
  const session = await useSecureSession(event)
  await session.update({
    authorization: `Bearer ${token}`,
  })
  return {
    message: 'Successfully logged in',
  }
})
