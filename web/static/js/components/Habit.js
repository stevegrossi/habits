import React from "react"
import ReactDOM from "react-dom"

class Habit extends React.Component {

  checkInAction() {
    return `/habits/${this.props.id}/check_ins`
  }

  deleteCheckInAction() {
    return `${this.checkInAction()}/${this.props.checkInId}`
  }

  isCheckedInToday() {
    !!this.props.checkInId
  }

  render() {
    return (
      <li className="Habit">
        {this.isCheckedInToday() &&
          <form className="CheckInForm" action={this.deleteCheckInAction()} method="post">
            <input name="_method" type="hidden" value="delete" />
            <input name="date" type="hidden" value="THE_DATE" />
            <input type="submit" value="Remove Check-In" className="CheckInForm-button CheckInForm-button--checkedIn" />
          </form>
        }
        {!this.isCheckedInToday() &&
          <form className="CheckInForm" action={this.checkInAction()} method="post">
            <input name="date" type="hidden" value="THE_DATE" />
            <input type="submit" value="Check In" className="CheckInForm-button" />
          </form>
        }

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
