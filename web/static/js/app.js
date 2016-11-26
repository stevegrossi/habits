import React from "react"
import ReactDOM from "react-dom"
import App from "./components/App"

const habitContainer = document.getElementById("habit-container")
if (habitContainer) {
  ReactDOM.render(<App />, habitContainer)
}
