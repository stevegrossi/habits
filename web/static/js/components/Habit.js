import React from 'react'
import ReactDOM from 'react-dom'
import { Link } from 'react-router'
import Auth from '../Auth'
import Request from '../Request'

class Habit extends React.Component {

  isCheckedIn() {
    return !!this.props.checkInId
  }

  toggleCheckIn() {
    const { id, checkInId } = this.props
    if (this.isCheckedIn()) {
      this.props.checkOut(id)
    } else {
      this.props.checkIn(id)
    }
  }

  buttonClassName() {
    let classNames = ['CheckInButton']
    if (this.isCheckedIn()) {
      classNames.push('CheckInButton--checkedIn')
    }
    return classNames.join(' ')
  }

  render() {
    const { id, name, streak } = this.props
    return (
      <li className="Habit">
        <button className={this.buttonClassName()} onClick={this.toggleCheckIn.bind(this)}>Check In</button>
        <Link to={`/habits/${id}`} className="Habit-name">{name}</Link>
        {streak > 0 &&
          <span className="Habit-streak">
            ➚ {streak}
          </span>
        }
      </li>
    )
  }
}

export default Habit
