import { defineNuxtConfig } from 'nuxt/config'

// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  modules: [
    '@nuxt/eslint',
    '@nuxtjs/tailwindcss',
    '@nuxt/fonts',
    '@vueuse/nuxt',
    '@nuxt/icon',
    'reka-ui/nuxt',
  ],
  devtools: { enabled: true },
  css: ['./app/global.css'],
  runtimeConfig: {
    public: {
      apiBase: '',
      mode: 'PRODUCTION',
    },
  },
  compatibilityDate: '2025-05-15',
  eslint: {
    config: {
      stylistic: true,
    },
  },
  tailwindcss: {
    config: {
      content: {
        files: [
          'app/**/*.vue',
        ],
      },
    },
  },
})
