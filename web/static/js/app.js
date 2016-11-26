import React from "react"
import ReactDOM from "react-dom"
import DateNav from "./components/DateNav"
import HabitList from "./components/HabitList"

const habitContainer = document.getElementById("habit-container")
if (habitContainer) {
  const habits = JSON.parse(habitContainer.dataset.habits)

  ReactDOM.render(
    <div>
      <DateNav />
      <HabitList data={habits} />
    </div>,
    habitContainer
  )
}
