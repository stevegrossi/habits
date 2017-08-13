import React from 'react'
import ReactDOM from 'react-dom'

class Progress extends React.Component {

  getStyle() {
    return {
      width: `${this.props.value / this.props.max * 100}%`
    }
  }

  render() {
    return (
      <div className="Progress">
        <div className="Progress-bar" style={this.getStyle()} />
      </div>
    )
  }
}

export default Progress
