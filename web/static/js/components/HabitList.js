import React from "react"
import ReactDOM from "react-dom"
import Habit from "./Habit"

class HabitList extends React.Component {
  constructor(state) {
    super(state)
    this.habits = [
      {
        id: 1,
        checkedIn: true,
        name: "Do a thing",
        streak: 12
      },
      {
        id: 2,
        checkedIn: false,
        name: "Do another thing",
        streak: 0
      },
      {
        id: 3,
        checkedIn: false,
        name: "Do more things",
        streak: 145
      },
    ]
  }

  render() {
    return (
      <ol className="HabitList">
        {this.habits.map((habit) =>
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
