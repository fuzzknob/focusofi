export default defineNuxtPlugin({
  enforce: 'pre',
  async setup() {
    await useAuth().getUser()
  },
})
