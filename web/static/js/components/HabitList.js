import React from "react"
import ReactDOM from "react-dom"
import Habit from "./Habit"

class HabitList extends React.Component {

  render() {
    return (
      <ol className="HabitList">
        {this.props.data.map((habit) =>
          <Habit name={habit.name}
                 checkedIn={habit.checkedIn}
                 streak={habit.streak}
                 id={habit.id}
                 key={habit.id} />
        )}
      </ol>
    )
  }
}

export default HabitList
