import React from 'react'
import ReactDOM from 'react-dom'
import { browserHistory, Link } from 'react-router'
import Request from '../Request'
import Loading from './Loading'

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
    const confirmed = confirm(`Are you sure you want to delete “${data.name}” and all of its check-ins?`)
    if (confirmed) {
      Request.delete(this.habitPath()).then(function(json) {
        browserHistory.push('/habits')
      })
    }
  }

  render() {
    const { data } = this.state
    return (
    <div>
      {!data && <Loading /> }
      {data &&
        <div className="center">
          <h2>{data.name}</h2>

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
        <a href="#" onClick={this.handleDelete.bind(this)}>× Delete</a>
      </p>
    </div>
    )
  }
}

export default HabitPage
