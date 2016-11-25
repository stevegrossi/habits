import React from "react"
import ReactDOM from "react-dom"

class Habit extends React.Component {

  checkInClassNames() {
    let names = ["CheckInForm-button"]
    if (this.props.checkedIn) {
      names.push("CheckInForm-button--checkedIn")
    }
    return names.join(" ")
  }

  checkInAction() {
    return `/habits/${this.props.id}/check_ins`
  }

  render() {
    return (
      <li className="Habit">
        <form className="CheckInForm" action={this.checkInAction()} method="post">
          <input name="_method" type="hidden" value="delete" />
          <input name="date" type="hidden" value="THE_DATE" />
          <input type="submit" value="Remove Check-In" className={this.checkInClassNames()} />
        </form>

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
