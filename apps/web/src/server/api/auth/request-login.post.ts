import { z } from 'zod'
import { addMinutes } from 'date-fns'

import { getRandomString } from '~/server/libs/utils'
import { tables, useDrizzle } from '~/server/services/drizzle'
// import { sendLoginOtpCodeEmail } from '~/server/emails/login_otp_email'

const requestLoginSchema = z.object({
  email: z.string().email(),
})
export default defineEventHandler(async (event) => {
  const result = await readValidatedBody(event, requestLoginSchema.safeParse)
  if (!result.success) {
    setResponseStatus(event, 400)
    return { message: 'There was an validation error', errors: result.error.issues }
  }
  const email = result.data.email
  const db = useDrizzle()
  let user = await db.query.users.findFirst({
    where: (users, { eq }) => (eq(users.email, email)),
  })
  if (!user) {
    user = await db.insert(tables.users).values({ email })
    if (!user) {
      setResponseStatus(event, 500)
      return { message: 'Could\'t create user' }
    }
  }
  const otpCode = getRandomString(5).toUpperCase()
  await db.insert(tables.emailOtps).values({
    otpCode,
    userId: user.id,
    expiration: addMinutes(new Date(), 10),
  })
  console.log({ email, otpCode })
  // sendLoginOtpCodeEmail(email, otpCode)
  return {
    message: 'Successfully request email',
  }
})
