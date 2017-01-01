import React from "react"
import ReactDOM from "react-dom"
import { browserHistory } from 'react-router'
import Request from '../Request'

class NewHabitForm extends React.Component {

  handleSubmit(event) {
    event.preventDefault()
    const { habitName } = this.refs
    const data = {
      habit: {
        name: habitName.value
      }
    }
    Request.post(`/api/v1/habits`, data).then(function() {
      browserHistory.push('/habits')
    })
  }

  render() {
    return (
    <form onSubmit={this.handleSubmit.bind(this)}>
      <label htmlFor="habit_name">Name</label>
      <input id="habit_name" name="habit[name]" ref="habitName" className="TextInput" autoFocus required />
      <input type="submit" value="Add Habit" className="Button" />
    </form>
    )
  }
}

export default NewHabitForm
