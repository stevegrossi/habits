import React from 'react'
import ReactDOM from 'react-dom'
import Habit from './Habit'
import Progress from './Progress'
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
      return !!habit.checkInId
    }).length
  }

  totalHabitsCount() {
    return this.state.habits.length
  }

  render() {
    return (
      <div>
        <Progress value={this.checkedInHabitsCount()} max={this.totalHabitsCount()}></Progress>
        <ol className="HabitList">
          {this.state.loading &&
            <li>Loading...</li>
          }
          {!this.state.loading && this.state.habits.map((habit) =>
            <Habit name={habit.name}
                   checkInId={habit.checkInId}
                   streak={habit.streak}
                   id={habit.id}
                   key={habit.id}
                   date={this.props.date} />
          )}
        </ol>
      </div>
    )
  }
}

export default HabitList
