import React from 'react'
import ReactDOM from 'react-dom'
import { Link } from 'react-router'
import DateNav from './DateNav'
import HabitList from './HabitList'
import 'whatwg-fetch'

class AllHabits extends React.Component {
  constructor(args) {
    super(args)
    this.state = { date: new Date() }
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
      <Link to="/habits/new" className="Button">Add a Habit</Link>
    </div>
    )
  }
}

export default AllHabits
