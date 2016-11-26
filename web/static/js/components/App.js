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
    this.state = {
      date: date
    }
  }

  render() {
    return (
    <div>
      <DateNav date={this.state.date} />
      <HabitList data={this.props.data} />
    </div>
    )
  }
}

export default App
