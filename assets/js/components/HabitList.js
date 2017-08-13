import React from 'react'
import ReactDOM from 'react-dom'
import Habit from './Habit'
import Progress from './Progress'
import Loading from './Loading'
import Request from '../Request'

class HabitList extends React.Component {

  constructor(props) {
    super(props)
    this.state = {
      loading: true,
      habits: []
    }
  }

  componentWillMount() {
    const endpoint = this.dateToEndpoint(this.props.date)
    this.fetchData(endpoint)
  }

  componentWillReceiveProps(nextProps) {
    const endpoint = this.dateToEndpoint(nextProps.date)
    this.fetchData(endpoint)
  }

  fetchData(endpoint) {
    const self = this;
    Request.get(endpoint).then(function(json) {
      self.setState({
        habits: json,
        loading: false
      })
    })
  }

  dateToEndpoint(date) {
    const dateString = [
      date.getFullYear(),
      ('0' + (date.getMonth() + 1)).slice(-2),
      ('0' + (date.getDate())).slice(-2)
    ].join('-')
    return `/api/v1/habits?date=${dateString}`
  }

  checkedInHabitsCount() {
    return this.state.habits.filter(function(habit) {
      return habit.checkedIn
    }).length
  }

  totalHabitsCount() {
    return this.state.habits.length
  }

  dateString() {
    const date = this.props.date
    return [
      date.getFullYear(),
      ('0' + (date.getMonth() + 1)).slice(-2),
      ('0' + (date.getDate())).slice(-2)
    ].join("-")
  }

  checkIn(habitId) {
    const self = this
    const endpoint = `/api/v1/habits/${habitId}/check_in?date=${this.dateString()}`
    Request.post(endpoint).then(function(updatedHabit) {
      self.updateHabits(updatedHabit)
    })
  }

  checkOut(habitId) {
    const self = this
    const endpoint = `/api/v1/habits/${habitId}/check_out?date=${this.dateString()}`
    Request.delete(endpoint).then(function(updatedHabit) {
      self.updateHabits(updatedHabit)
    })
  }

  updateHabits(updatedHabit) {
    const { habits } = this.state
    const habit = habits.find(function(habit) {
      return habit.id == updatedHabit.id
    })
    const habitIndex = habits.indexOf(habit)
    this.setState({
      habits: [
        ...habits.slice(0, habitIndex),
        updatedHabit,
        ...habits.slice(habitIndex + 1)
      ]
    })
  }

  render() {
    return (
      <div>
        {this.state.loading && <Loading /> }
        {!this.state.loading &&
          <div>
            <Progress value={this.checkedInHabitsCount()} max={this.totalHabitsCount()}></Progress>
            <ol className="HabitList">
              {this.state.habits.map((habit) =>
                <Habit {...habit}
                       key={habit.id}
                       checkIn={this.checkIn.bind(this)}
                       checkOut={this.checkOut.bind(this)} />
              )}
            </ol>
          </div>
        }
      </div>
    )
  }
}

export default HabitList
