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
            <svg className="Habit-streakIcon" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlnsXlink="http://www.w3.org/1999/xlink" width="14" height="28" viewBox="0 0 14 28">
              <path d="M13.828 8.844c0.172 0.187 0.219 0.453 0.109 0.688l-8.437 18.078c-0.125 0.234-0.375 0.391-0.656 0.391-0.063 0-0.141-0.016-0.219-0.031-0.344-0.109-0.547-0.438-0.469-0.766l3.078-12.625-6.344 1.578c-0.063 0.016-0.125 0.016-0.187 0.016-0.172 0-0.359-0.063-0.484-0.172-0.187-0.156-0.25-0.391-0.203-0.609l3.141-12.891c0.078-0.297 0.359-0.5 0.688-0.5h5.125c0.391 0 0.703 0.297 0.703 0.656 0 0.094-0.031 0.187-0.078 0.281l-2.672 7.234 6.188-1.531c0.063-0.016 0.125-0.031 0.187-0.031 0.203 0 0.391 0.094 0.531 0.234z"></path>
            </svg>
            {streak}
          </span>
        }
      </li>
    )
  }
}

export default Habit
