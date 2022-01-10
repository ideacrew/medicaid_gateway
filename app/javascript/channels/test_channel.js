import consumer from './consumer'

// TestChannel is created only in lower envs for debugging
if (process.env.MG_DEBUG === 'true') {
    consumer.subscriptions.create('TestChannel', {
        connected() {
            this.send({ message: 'Client is live' })
        },

        received(data) {
            console.log(data)
        }
    })
}