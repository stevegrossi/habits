import React from "react"
import ReactDOM from "react-dom"
import DateNav from "./DateNav"
import HabitList from "./HabitList"

class App extends React.Component {

  render() {
    return (
    <div>
      <DateNav date={this.props.date} />
      <HabitList data={this.props.data} />
    </div>
    )
  }
}

export default App
