import React from 'react'
import ReactDOM from 'react-dom'
import Request from '../Request'
import Session from './Session'

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
        {!this.state.data &&
          <span>Loading...</span>
        }
        <ol className="ActionList">
        {this.state.data && this.state.data.map((session) =>
          <Session token={session.token}
                   createdAt={session.createdAt}
                   location={session.location}
                   renderParent={this.fetchData.bind(this)}
                   key={session.token} />
        )}
        </ol>
      </div>
    )
  }
}

export default SessionsPage
