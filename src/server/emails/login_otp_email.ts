import { sendEmail } from '@/server/services/email'

function renderTemplate({ otpCode }: { otpCode: string }) {
  return `
<!doctype html>
<html>
    <head>
        <title>Break Timer Login OTP</title>
        <style>
            .otp {
                padding: 15px;
                background: skyblue;
                text-align: center;
                font-weight: bolder;
                font-size: 25px;
                letter-spacing: 3px;
            }
        </style>
    </head>
    <body style="font-family: Inter, Arial, sans-serif">
        <p>Hi there,</p>
        <p>You're One Time Password (OTP) to login to break timer is:</p>
        <div class="otp">${otpCode}</div>
        <p>If you did not request this email, you can safely ignore it.</p>
    </body>
</html>
`
}

export async function sendLoginOtpCodeEmail(
  email: string,
  otpCode: string,
) {
  const message = renderTemplate({ otpCode: otpCode })
  return await sendEmail({
    to: email,
    subject: 'Break Timer Login OTP',
    body: message,
  })
}
