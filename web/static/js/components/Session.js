import React from 'react'
import ReactDOM from 'react-dom'
import { distanceInWordsToNow } from 'date-fns'
import Request from '../Request'

class Session extends React.Component {

  handleDelete() {
    const self = this
    const endpoint = `/api/v1/sessions/${this.props.token}`
    Request.delete(endpoint).then(function() {
      self.props.renderParent()
    })
  }

  formatCreatedAt() {
    const date = new Date(this.props.createdAt)
    return distanceInWordsToNow(date, { addSuffix: true })
  }

  render() {
    return (
      <li className="ActionList-item">
        <div>
          <div>{this.props.location}</div>
          <div className="ActionList-itemMeta">{this.formatCreatedAt()}</div>
        </div>
        <a className="ActionList-action" href="#" onClick={this.handleDelete.bind(this)}>×</a>
      </li>
    )
  }
}

export default Session
