import React from "react"
import ReactDOM from "react-dom"

class Habit extends React.Component {
  constructor(args) {
    super(args)
    this.state = {
      isCheckedIn: !!this.props.checkInId
    }
  }

  dateString() {
    const date = this.props.date;
    return [
      date.getFullYear(),
      date.getMonth() + 1,
      date.getDate()
    ].join("-")
  }

  toggleCheckIn() {
    if (this.state.isCheckedIn) {
      this.checkOut()
    } else {
      this.checkIn()
    }
  }

  checkIn() {
    const self = this;
    const data = fetch(`/api/v1/habits/${this.props.id}/check_in?date=${this.dateString()}`, {
      method: 'post',
      credentials: 'include',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
    })
    .then(function(response) {
      return response.json()
    }).then(function(json) {
      self.setState({ isCheckedIn: true })
    }).catch(function(error) {
      console.error('Error fetching JSON:', error)
    })
  }

  checkOut() {
    const self = this;
    const data = fetch(`/api/v1/habits/${this.props.id}/check_out?date=${this.dateString()}`, {
      method: 'post',
      credentials: 'include',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
    })
    .then(function(response) {
      return response.json()
    }).then(function(json) {
      self.setState({ isCheckedIn: false })
    }).catch(function(error) {
      console.error('Error fetching JSON:', error)
    })
  }

  checkInButtonClassName() {
    let classNames = ["CheckInButton"]
    if (this.state.isCheckedIn) {
      classNames.push("CheckInButton--checkedIn")
    }
    return classNames.join(" ")
  }

  render() {
    return (
      <li className="Habit">
        <button className={this.checkInButtonClassName()} onClick={this.toggleCheckIn.bind(this)}>Check In</button>
        <span className="Habit-name">{this.props.name}</span>
        {this.props.streak > 0 &&
          <span className="Habit-streak">
            ➚ {this.props.streak}
          </span>
        }
      </li>
    )
  }
}

export default Habit
