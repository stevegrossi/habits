import React from 'react'
import ReactDOM from 'react-dom'
import { Socket } from 'phoenix'

class NotificationList extends React.Component {

  constructor(props) {
    super(props)
    this.state = {
      notifications: []
    }
    this.appendNotification = this.appendNotification.bind(this)
  }

  componentWillMount() {
    let socket = new Socket("/socket")
    socket.connect()
    socket.onClose((e) => console.log("Socket: closed connection"))

    let room = socket.channel("notifications", {})
    room.join()
      .receive("error", () => console.log("Notifications: error connecting"))
      .receive("ok",    () => console.log("Notifications: connected"))
    room.on("notification:new", this.appendNotification );
  }

  appendNotification(notification) {
    this.setState({
      notifications: [...this.state.notifications, notification]
    })
  }

  render() {
    return (
      <div className="NotificationList">
        <ul className="NotificationList-list">
          {this.state.notifications.map((notification, index) =>
            <li className="NotificationList-item" key={index}>{notification.message}</li>
          )}
        </ul>
      </div>
    )
  }

}

export default NotificationList
