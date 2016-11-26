import React from "react"
import ReactDOM from "react-dom"
import DateNav from "./DateNav"
import HabitList from "./HabitList"

class App extends React.Component {
  constructor(args) {
    super(args)

    const [_empty, year, month, day] = window.location.pathname.split("/")
    const date = new Date(
      parseInt(year),
      parseInt(month) - 1,
      parseInt(day)
    )
    this.state = { date: date }
  }

  goToPrev() {
    const date = new Date(this.state.date)
    const previousDay = new Date(date.setDate(date.getDate() - 1));

    this.setState({ date: previousDay })
  }

  goToNext() {
    const date = new Date(this.state.date)
    const nextDay = new Date(date.setDate(date.getDate() + 1));

    this.setState({ date: nextDay })
  }

  render() {
    return (
    <div>
      <DateNav goToPrev={this.goToPrev.bind(this)}
               goToNext={this.goToNext.bind(this)}
               date={this.state.date} />
      <HabitList date={this.state.date} />
    </div>
    )
  }
}

export default App
