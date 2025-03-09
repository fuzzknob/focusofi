export default defineWebSocketHandler({
  open(peer) {
    console.log(peer.id, ' joined the chat')
    peer.subscribe('something')
  },
  message(peer, message) {
    console.log(message.text())
    // peer.publish('something', {
    //   message: 'hello',
    // })
    peer.publish('something', { message: 'hello' })
  },
  close() {
    console.log('connection closed')
  },
})
