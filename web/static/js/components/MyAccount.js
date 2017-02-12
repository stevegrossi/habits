import React from 'react'
import ReactDOM from 'react-dom'
import { Link } from 'react-router'
import Gravatar from './Gravatar'
import Loading from './Loading'
import Request from '../Request'
import CheckInChart from './CheckInChart'

class MyAccount extends React.Component {

  constructor(props) {
    super(props)
    this.state = {
      data: null
    }
  }

  componentWillMount() {
    const self = this
    Request.get('/api/v1/account').then(function(json) {
      self.setState({
        data: json
      })
    })
  }

  totalCheckIns() {
    const { checkInData } = this.state.data
    const checkInCount = checkInData.reduce((total, count) => total + count, 0)
    return Number(checkInCount).toLocaleString()
  }

  render() {
    return (
      <div className="center">
        {!this.state.data && <Loading />}
        {this.state.data &&
          <div>
            <CheckInChart data={this.state.data.checkInData} />
            <h2>
              <Gravatar email={this.state.data.email} size="100" />
              &nbsp;{this.state.data.email}
            </h2>
            <p><Link to="/sessions">Active Sessions</Link></p>
            <p className="Metric">
              <span className="Metric-title">Total Check-Ins</span>
              <span className="Metric-number">{this.totalCheckIns()}</span>
            </p>
          </div>
        }
      </div>
    )
  }
}

export default MyAccount
