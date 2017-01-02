import React from 'react'
import ReactDOM from 'react-dom'
import { Link } from 'react-router'
import Request from '../Request'

class HabitPage extends React.Component {

  constructor(props) {
    super(props)
    this.state = {
      data: null
    }
  }

  componentWillMount() {
    const self = this;
    Request.get(`/api/v1/habits/${this.props.params.id}`).then(function(json) {
      self.setState({ data: json })
    })
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
      <p className="center">
        <Link to="/habits">← Back</Link>
      </p>
    </div>
    )
  }
}

export default HabitPage
