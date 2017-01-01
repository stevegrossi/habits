import React from "react"
import ReactDOM from "react-dom"
import Habit from "./Habit"
import Auth from "../Auth"

class HabitList extends React.Component {

  constructor(props) {
    super(props)
    this.state = { data: [] }
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
    const data = fetch(endpoint, {
      credentials: 'include',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': `Token token="${Auth.token()}"`
      },
    })
    .then(function(response) {
      return response.json()
    }).then(function(json) {
      self.setState({ data: JSON.parse(json) })
    }).catch(function(error) {
      console.error('Error fetching JSON:', error)
    })
  }

  dateToEndpoint(date) {
    const dateString = [
      date.getFullYear(),
      ('0' + (date.getMonth() + 1)).slice(-2),
      ('0' + (date.getDate())).slice(-2)
    ].join("-")
    return "/api/v1/habits?date=" + dateString
  }

  render() {
    return (
      <ol className="HabitList">
        {this.state.data.map((habit) =>
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
