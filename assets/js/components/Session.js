import React from 'react'
import ReactDOM from 'react-dom'
import { browserHistory } from 'react-router'
import { distanceInWordsToNow } from 'date-fns'
import Request from '../Request'
import Auth from '../Auth'

class Session extends React.Component {

  handleDelete(event) {
    event.preventDefault()
    const { renderParent, token } = this.props
    const endpoint = `/api/v1/sessions/${token}`
    if (this.isCurrentSession()) {
      const confirmed = confirm(`This is your current session. Deleting it will log you out. Are you sure?`)
      if (confirmed) {
        Auth.logOut().then(function() {
          browserHistory.push('/')
        })
      }
    } else {
      Request.delete(endpoint).then(function() {
        renderParent()
      })
    }
  }

  formatCreatedAt() {
    const date = new Date(this.props.createdAt)
    return distanceInWordsToNow(date, { addSuffix: true })
  }

  isCurrentSession() {
    return this.props.token == Auth.token()
  }

  render() {
    return (
      <li className="ActionList-item">
        <div>
          <div>
            {this.props.location}
            {this.isCurrentSession() &&
              ' (Current)'
            }
          </div>
          <div className="ActionList-itemMeta">{this.formatCreatedAt()}</div>
        </div>
        <a className="ActionList-action" href="#" onClick={this.handleDelete.bind(this)}>×</a>
      </li>
    )
  }
}

export default Session
