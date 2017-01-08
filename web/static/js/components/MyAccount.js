import React from 'react'
import ReactDOM from 'react-dom'
import { Link } from 'react-router'
import Gravatar from './Gravatar'
import Loading from './Loading'
import Request from '../Request'

class MyAccount extends React.Component {

  constructor(props) {
    super(props)
    this.state = {
      loading: true,
      email: null,
      totalCheckIns: 0
    }
  }

  componentWillMount() {
    const self = this
    Request.get('/api/v1/account').then(function(json) {
      self.setState({
        loading: false,
        email: json.email,
        totalCheckIns: json.totalCheckIns
      })
    })
  }

  render() {
    return (
      <div className="center">
        {this.state.loading && <Loading />}
        {!this.state.loading &&
          <div>
            <Gravatar email={this.state.email} size="400" />
            <h2>{this.state.email}</h2>
            <p><Link to="/sessions">Active Sessions</Link></p>
            <p className="Metric">
              <span className="Metric-title">Total Check-Ins</span>
              <span className="Metric-number">{Number(this.state.totalCheckIns).toLocaleString()}</span>
            </p>
          </div>
        }
      </div>
    )
  }
}

export default MyAccount
