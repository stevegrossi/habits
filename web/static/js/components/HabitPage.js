import React from 'react'
import ReactDOM from 'react-dom'
import { browserHistory, Link } from 'react-router'
import Request from '../Request'
import Loading from './Loading'

class HabitPage extends React.Component {

  constructor(props) {
    super(props)
    this.state = {
      data: null,
      editing: false
    }
    this.handleEdit = this.handleEdit.bind(this)
    this.cancelEdit = this.cancelEdit.bind(this)
    this.submitEdit = this.submitEdit.bind(this)
    this.handleDelete = this.handleDelete.bind(this)
  }

  habitPath() {
    return `/api/v1/habits/${this.props.params.id}`
  }

  componentWillMount() {
    const self = this;
    Request.get(this.habitPath()).then(function(json) {
      self.setState({ data: json })
    })
  }

  handleDelete(event) {
    event.preventDefault()
    const { data: { name } } = this.state
    const confirmed = confirm(`Are you sure you want to delete “${name}” and all of its check-ins?`)
    if (confirmed) {
      Request.delete(this.habitPath()).then(function(json) {
        browserHistory.push('/habits')
      })
    }
  }

  handleEdit(event) {
    this.setState({ editing: true })
  }

  cancelEdit(event) {
    this.setState({ editing: false })
  }

  submitEdit() {
    const attributes = { name: this.nameInput.value }
    const self = this
    Request.patch(this.habitPath(), attributes).then(function(json) {
      const newData = { ...self.state.data, ...json }
      self.setState({ editing: false, data: newData })
    })
  }

  selectOnFocus(event) {
    event.target.select()
  }

  render() {
    const { data } = this.state
    return (
    <div>
      {!data && <Loading /> }
      {data &&
        <div className="center">
          {this.state.editing &&
            <div>
              <input ref={(node) => this.nameInput = node } defaultValue={data.name} className="TextInput" type="text" autoFocus onFocus={this.selectOnFocus} />
              <button className="Button" onClick={this.submitEdit}>Save</button>
              <button className="Button" onClick={this.cancelEdit}>Cancel</button>
            </div>
          }
          {!this.state.editing &&
            <h2>
              {data.name}
              <a href="#" onClick={this.handleEdit}>
                <svg className="InlineIcon muted" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16">
                  <path d="M15 16H1a1 1 0 0 1-1-1V1a1 1 0 0 1 1-1h10L9 2H2v12h12V7l2-2v10a1 1 0 0 1-1 1zM4 12V9l9-9h1l2 2v1l-9 9H4zm4.5-3.5L14 3l-1-1-5.5 5.5 1 1zM6 9l-1 1v1h1l1-1-1-1z"/>
                </svg>
              </a>
            </h2>
          }

          <p className="Metric">
            <span className="Metric-title">Current Streak</span>
            <span className="Metric-number">
              <svg className="StreakIcon" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlnsXlink="http://www.w3.org/1999/xlink" width="14" height="28" viewBox="0 0 14 28">
                <path d="M13.828 8.844c0.172 0.187 0.219 0.453 0.109 0.688l-8.437 18.078c-0.125 0.234-0.375 0.391-0.656 0.391-0.063 0-0.141-0.016-0.219-0.031-0.344-0.109-0.547-0.438-0.469-0.766l3.078-12.625-6.344 1.578c-0.063 0.016-0.125 0.016-0.187 0.016-0.172 0-0.359-0.063-0.484-0.172-0.187-0.156-0.25-0.391-0.203-0.609l3.141-12.891c0.078-0.297 0.359-0.5 0.688-0.5h5.125c0.391 0 0.703 0.297 0.703 0.656 0 0.094-0.031 0.187-0.078 0.281l-2.672 7.234 6.188-1.531c0.063-0.016 0.125-0.031 0.187-0.031 0.203 0 0.391 0.094 0.531 0.234z"></path>
              </svg>
              {Number(data.currentStreak).toLocaleString()}
            </span>
          </p>

          <p className="Metric">
            <span className="Metric-title">Longest Streak</span>
            <span className="Metric-number">
              {Number(data.longestStreak).toLocaleString()}
            </span>
          </p>

          <p className="Metric">
            <span className="Metric-title">Total Check-Ins</span>
            <span className="Metric-number">
              {Number(data.totalCheckIns).toLocaleString()}
            </span>
          </p>
        </div>
      }
      <p className="FooterNav">
        <Link to="/habits">← Back</Link>
        <a href="#" onClick={this.handleDelete}>× Delete</a>
      </p>
    </div>
    )
  }
}

export default HabitPage
