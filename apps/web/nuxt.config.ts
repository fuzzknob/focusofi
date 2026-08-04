import { defineNuxtConfig } from 'nuxt/config'
import tailwindcss from '@tailwindcss/vite'

// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  modules: [
    '@nuxt/eslint',
    '@nuxt/fonts',
    '@vueuse/nuxt',
    '@nuxt/icon',
    'reka-ui/nuxt',
  ],
  devtools: { enabled: true },
  css: ['~/global.css'],
  runtimeConfig: {
    public: {
      apiBase: '',
      mode: 'PRODUCTION',
    },
  },
  compatibilityDate: '2025-07-15',
  vite: {
    plugins: [tailwindcss()],
  },
  eslint: {
    config: {
      stylistic: true,
    },
  },
  icon: {
    mode: 'css',
    cssLayer: 'base',
  },
})
