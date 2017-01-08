import React from 'react'
import ReactDOM from 'react-dom'
import { Link } from 'react-router'
import Request from '../Request'
import Session from './Session'
import Loading from './Loading'

class SessionsPage extends React.Component {

  constructor(props) {
    super(props)
    this.state = {
      data: null
    }
  }

  componentWillMount() {
    this.fetchData()
  }

  fetchData() {
    const self = this
    Request.get('/api/v1/sessions').then(function(json) {
      self.setState({ data: json })
    })
  }

  render() {
    return (
      <div>
        <h2>Active Sessions</h2>
        {!this.state.data && <Loading /> }
        <ol className="ActionList">
        {this.state.data && this.state.data.map((session) =>
          <Session token={session.token}
                   createdAt={session.createdAt}
                   location={session.location}
                   renderParent={this.fetchData.bind(this)}
                   key={session.token} />
        )}
        </ol>
        <p className="FooterNav">
          <Link to="/account">← Back</Link>
        </p>
      </div>
    )
  }
}

export default SessionsPage
