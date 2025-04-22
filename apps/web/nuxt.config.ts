import tailwindcss from '@tailwindcss/vite'

// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  modules: [
    '@nuxt/eslint',
    '@nuxt/fonts',
    '@pinia/nuxt',
    '@nuxthub/core',
    '@vueuse/nuxt',
  ],
  devtools: { enabled: true },
  css: ['~/global.css'],
  runtimeConfig: {
    cookiePassword: '',
    resendApiKey: '',
    emailFromAddress: '',
    sseEventSecret: '',
    public: {
      sseUrl: '',
      apiBase: '',
    },
  },
  srcDir: 'src/',
  compatibilityDate: '2024-11-01',
  hub: {},
  vite: {
    plugins: [
      tailwindcss(),
    ],
  },
  eslint: {
    config: {
      stylistic: true,
    },
  },
})
