import tailwindcss from '@tailwindcss/vite'

// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  modules: ['@nuxt/eslint', '@nuxt/fonts', '@pinia/nuxt', '@nuxthub/core'],
  devtools: { enabled: true },
  css: ['~/global.css'],
  runtimeConfig: {
    cookiePassword: '',
    resendApiKey: '',
    emailFromAddress: '',
  },
  srcDir: 'src/',
  compatibilityDate: '2024-11-01',
  nitro: {
    experimental: {
      tasks: true,
      openAPI: true,
    },
  },
  hub: {
    database: true,
    cache: true,
    kv: true,
  },
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
