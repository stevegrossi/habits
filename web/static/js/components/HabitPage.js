import React from 'react'
import ReactDOM from 'react-dom'
import { browserHistory, Link } from 'react-router'
import Request from '../Request'
import Loading from './Loading'
import Icon from './Icon'
import CheckInChart from './CheckInChart'

class HabitPage extends React.Component {

  constructor(props) {
    super(props)
    this.state = {
      data: null,
      editing: false
    }
    this.handleEdit = this.handleEdit.bind(this)
    this.cancelEdit = this.cancelEdit.bind(this)
    this.handleSubmit = this.handleSubmit.bind(this)
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

  handleSubmit(e) {
    e.preventDefault()
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
            <form onSubmit={this.handleSubmit} className="InlineForm">
              <input className="InlineForm-input TextInput" ref={(node) => this.nameInput = node } defaultValue={data.name} type="text" autoFocus onFocus={this.selectOnFocus} />
              <button className="InlineForm-button">
                <Icon name="accept" />
              </button>
              <button className="InlineForm-button" onClick={this.cancelEdit}>
                <Icon name="cancel" />
              </button>
            </form>
          }
          {!this.state.editing &&
            <h2 className="mt0">
              {data.name}
              <a href="#" onClick={this.handleEdit}>
                <Icon className="Icon--inline muted" name="edit" />
              </a>
            </h2>
          }

          <CheckInChart data={this.state.data.checkInData} />

          <p className="Metric">
            <span className="Metric-title">Current Streak</span>
            <span className="Metric-number">
              <Icon name="streak" />
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
