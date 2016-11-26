import React from "react"
import ReactDOM from "react-dom"
import App from "./components/App"

const habitContainer = document.getElementById("habit-container")
if (habitContainer) {
  const habits = JSON.parse(habitContainer.dataset.habits)

  ReactDOM.render(
    <App data={habits} />,
    habitContainer
  )
}
