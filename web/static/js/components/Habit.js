import React from "react"
import ReactDOM from "react-dom"

class Habit extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      isCheckedIn: !!this.props.checkInId,
      streak: this.props.streak
    }
  }

  componentWillReceiveProps(newProps) {
    this.setState({ isCheckedIn: !!newProps.checkInId })
  }

  dateString() {
    const date = this.props.date;
    return [
      date.getFullYear(),
      ('0' + (date.getMonth() + 1)).slice(-2),
      ('0' + (date.getDate())).slice(-2)
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
      const streak = JSON.parse(json).streak
      self.setState({
        isCheckedIn: true,
        streak: streak
      })
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
      const streak = JSON.parse(json).streak
      self.setState({
        isCheckedIn: false,
        streak: streak
      })
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
      <li className="Habit" onClick={this.toggleCheckIn.bind(this)}>
        <button className={this.checkInButtonClassName()}>Check In</button>
        <span className="Habit-name">{this.props.name}</span>
        {this.state.streak > 0 &&
          <span className="Habit-streak">
            ➚ {this.state.streak}
          </span>
        }
      </li>
    )
  }
}

export default Habit
