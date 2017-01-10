import React from 'react'
import ReactDOM from 'react-dom'
import { isToday, isYesterday, isThisWeek, isThisYear, format } from 'date-fns'

class DateNav extends React.Component {

  currentDateString() {
    const { date } = this.props
    if (isToday(date)) {
      return 'Today'
    } else if (isYesterday(date)) {
      return 'Yesterday'
    } else if (isThisWeek(date)) {
      return format(date, 'dddd')
    } else if (isThisYear(date)) {
      return format(date, 'MMMM D')
    } else {
      return format(date, 'MMMM D, YYYY')
    }
  }

  showNextDate() {
    return !isToday(this.props.date)
  }

  render() {
    return (
      <div className="DateNav">
        <span className="DateNav-arrow">
          <a onClick={this.props.goToPrev}>«</a>
        </span>
        {this.currentDateString()}
        <span className="DateNav-arrow">
          {this.showNextDate() &&
            <a onClick={this.props.goToNext}>»</a>
          }
        </span>
      </div>
    )
  }
}

export default DateNav
