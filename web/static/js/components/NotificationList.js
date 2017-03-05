import React from 'react'
import ReactDOM from 'react-dom'
import { Socket } from 'phoenix'

class NotificationList extends React.Component {

  constructor(props) {
    super(props)
    this.state = {
      queue: [],
      notification: null
    }
    this.enqueueNotification = this.enqueueNotification.bind(this)
  }

  componentWillMount() {
    let socket = new Socket("/socket")
    socket.connect()
    socket.onClose((e) => console.log("Socket: closed connection"))

    let room = socket.channel("notifications", {})
    room.join()
      .receive("error", () => console.log("Notifications: error connecting"))
      .receive("ok",    () => console.log("Notifications: connected"))
    room.on("notification:new", this.enqueueNotification );
  }

  enqueueNotification(notification) {
    this.setState({
      queue: [...this.state.queue, notification]
    })
    this.processQueue()
  }

  processQueue() {
    if (this.state.queue.length !== 1) return;
    setTimeout(() => {
      this.setState({
        queue: this.state.queue.slice(1)
      })
      this.processQueue()
    }, 2000)
  }

  render() {
    const currentNotification = this.state.queue[0]
    return (
      <div className="NotificationList">
        <ul className="NotificationList-list">
          {currentNotification &&
            <li className="NotificationList-item" key={`${currentNotification.subject}--${currentNotification.message}`}>
              <div className="NotificationList-subject">{currentNotification.subject}</div>
              <div>{currentNotification.message}</div>
            </li>
          }
        </ul>
      </div>
    )
  }

}

export default NotificationList
