export default defineWebSocketHandler({
  open(peer) {
    console.log(peer.id, ' joined the chat')
    peer.subscribe('timer-channel')
  },
  message(peer, message) {
    console.log(message.text())
    peer.publish('timer-channel', { message: 'hello' })
  },
  close() {
    console.log('connection closed')
  },
})
