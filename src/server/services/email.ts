import { Resend } from 'resend'

const resend = new Resend(process.env.RESEND_API_KEY)

export async function sendEmail({ to, subject, body = '' }: { to: string, subject: string, body?: string }) {
  const fromAddress = process.env.EMAIL_FROM_ADDRESS ?? 'no-reply@break-support.fuzzknob.com'
  await resend.emails.send({
    from: fromAddress,
    to: [to],
    subject,
    html: body,
  })
}
