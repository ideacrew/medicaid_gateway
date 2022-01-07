import consumer from './consumer'

// TestChannel is created only in lower envs for debugging purposes
if (String(process.env.MG_DEBUG) === 'true') {
    consumer.subscriptions.create('TestChannel', {
        connected() {
            this.send({ message: 'Client is live' })
        },

        received(data) {
            console.log(data)
        }
    })
}