import React from 'react'
import ReactDOM from 'react-dom'
import { browserHistory, Link } from 'react-router'
import Request from '../Request'

class HabitPage extends React.Component {

  constructor(props) {
    super(props)
    this.state = {
      data: null
    }
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
    const confirmed = confirm(`Are you sure you want to delete “${this.state.data.name}” and all of its check-ins?`)
    if (confirmed) {
      const self = this;
      Request.delete(this.habitPath()).then(function(json) {
        browserHistory.push('/habits')
      })
    }
  }

  render() {
    return (
    <div>
      {!this.state.data && 'Loading...'}
      {this.state.data &&
        <div className="center">
          <h2>{this.state.data.name}</h2>
          <p className="Metric">
            <span className="Metric-title">Total Check-Ins</span>
            <span className="Metric-number">{Number(this.state.data.totalCheckIns).toLocaleString()}</span>
          </p>
        </div>
      }
      <p className="FooterNav">
        <Link to="/habits">← Back</Link>
        <a href="#" onClick={this.handleDelete.bind(this)}>× Delete</a>
      </p>
    </div>
    )
  }
}

export default HabitPage
