import React from 'react'
import ReactDOM from 'react-dom'
import { Link } from 'react-router'
import Auth from '../Auth'
import Request from '../Request'
import Icon from './Icon'

class Habit extends React.Component {

  toggleCheckIn() {
    const { id, checkedIn, checkOut, checkIn } = this.props
    if (checkedIn) {
      checkOut(id)
    } else {
      checkIn(id)
    }
  }

  buttonClassName() {
    let classNames = ['CheckInButton']
    if (this.props.checkedIn) {
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
            <Icon name="streak" className="StreakIcon" />
            {streak}
          </span>
        }
      </li>
    )
  }
}

export default Habit
