import { z } from 'zod'
import { addMonths, isAfter } from 'date-fns'

import { getRandomString } from '~/server/libs/utils'
import { eq, tables, useDrizzle } from '~/server/services/drizzle'
import { useSecureSession } from '~/server/libs/secure_session'

const loginWithOtpSchema = z.object({
  otp: z.string().length(5),
  mobile: z.boolean().default(false),
})

export default defineEventHandler(async (event) => {
  const result = await readValidatedBody(event, loginWithOtpSchema.safeParse)
  if (!result.success) {
    setResponseStatus(event, 400)
    return { message: 'There was an validation error', errors: result.error.issues }
  }
  const db = useDrizzle()
  const { otp, mobile } = result.data
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
    }).where(eq(tables.users.id, user.id))
  }
  const token = getRandomString(30)
  await hubKV().setItem(token, {
    token,
    expiration: addMonths(new Date(), 3),
    user: {
      id: user.id,
      email: user.email,
      role: user.role,
    },
  }, {
    // 3 months
    ttl: 60 * 60 * 24 * 30 * 3,
  })
  if (mobile) {
    return {
      token,
    }
  }
  const session = await useSecureSession(event)
  await session.update({
    authorization: `Bearer ${token}`,
  })
  return {
    message: 'Successfully logged in',
  }
})
