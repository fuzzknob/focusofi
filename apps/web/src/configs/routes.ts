const baseUrl = process.env.NUXT_PUBLIC_API_BASE as string

const base = (url: string) => `${baseUrl}/${url}`

export const apiRoutes = {
  auth: {
    me: base('auth/me'),
    logout: base('auth/logout'),
    requestLogin: base('auth/request-login'),
    loginWithOtp: base('auth/login-with-otp'),
  },
  background: {
    random: base('background'),
    all: base('background/all'),
    create: base('background'),
    delete: (id: string) => base(`background/${id}`),
  },
  settings: {
    index: base('settings'),
  },
  timer: {
    index: base('timer'),
    start: base('timer/start'),
    stop: base('timer/stop'),
    reset: base('timer/reset'),
    pause: base('timer/pause'),
    resume: base('/timer/resume'),
  },
}
