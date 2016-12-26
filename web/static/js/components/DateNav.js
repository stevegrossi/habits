import React from "react"
import ReactDOM from "react-dom"

class DateNav extends React.Component {

  monthName(index) {
    const monthNames = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ]
    return monthNames[index]
  }

  currentDateString() {
    const date = new Date(this.props.date)
    const dateParts = [
      date.getDate(),
      this.monthName(date.getMonth()),
      date.getFullYear()
    ]
    return dateParts.join(" ")
  }

  showNextDate() {
    const today = (new Date()).setHours(0, 0, 0, 0)
    return this.props.date < today
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
