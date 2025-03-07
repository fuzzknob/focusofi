import { Resend } from 'resend'

export async function sendEmail({ to, subject, body = '' }: { to: string, subject: string, body?: string }) {
  const config = useRuntimeConfig()
  const resend = new Resend(config.resendApiKey)
  const fromAddress = process.env.EMAIL_FROM_ADDRESS ?? 'no-reply@break-support.fuzzknob.com'
  await resend.emails.send({
    from: fromAddress,
    to: [to],
    subject,
    html: body,
  })
}
