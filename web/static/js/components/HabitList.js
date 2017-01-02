import React from 'react'
import ReactDOM from 'react-dom'
import Habit from './Habit'
import Request from '../Request'

class HabitList extends React.Component {

  constructor(props) {
    super(props)
    this.state = {
      loading: true,
      data: []
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
        data: json,
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

  render() {
    return (
      <ol className="HabitList">
        {this.state.loading &&
          <li>Loading...</li>
        }
        {!this.state.loading && this.state.data.map((habit) =>
          <Habit name={habit.name}
                 checkInId={habit.checkInId}
                 streak={habit.streak}
                 id={habit.id}
                 key={habit.id}
                 date={this.props.date} />
        )}
      </ol>
    )
  }
}

export default HabitList
