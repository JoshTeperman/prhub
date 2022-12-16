import consumer from './consumer';

consumer.subscriptions.create('CommentsChannel', {
  connected() {
    console.log('connected to Comments Channel');
  }
})
