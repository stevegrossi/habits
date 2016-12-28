import React from "react"
import ReactDOM from "react-dom"
import App from "./components/App"
import Main from "./components/Main"

const habitContainer = document.getElementById("habit-container")
if (habitContainer) {
  ReactDOM.render(<App />, habitContainer)
}

const mainContainer = document.getElementById("main")
if (mainContainer) {
  ReactDOM.render(<Main />, mainContainer)
}
