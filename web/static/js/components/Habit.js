import React from 'react'
import ReactDOM from 'react-dom'
import { Link } from 'react-router'
import Auth from '../Auth'
import Request from '../Request'

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
    const self = this
    const endpoint = `/api/v1/habits/${this.props.id}/check_in?date=${this.dateString()}`
    Request.post(endpoint).then(function(json) {
      self.setState({ isCheckedIn: true, streak: json.streak })
    })
  }

  checkOut() {
    const self = this
    const endpoint = `/api/v1/habits/${this.props.id}/check_out?date=${this.dateString()}`
    Request.post(endpoint).then(function(json) {
      self.setState({ isCheckedIn: false, streak: json.streak })
    })
  }

  checkInButtonClassName() {
    let classNames = ['CheckInButton']
    if (this.state.isCheckedIn) {
      classNames.push('CheckInButton--checkedIn')
    }
    return classNames.join(' ')
  }

  render() {
    return (
      <li className="Habit">
        <button className={this.checkInButtonClassName()} onClick={this.toggleCheckIn.bind(this)}>Check In</button>
        <Link to={`/habits/${this.props.id}`} className="Habit-name">{this.props.name}</Link>
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
