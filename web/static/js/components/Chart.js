import React from 'react'
import ReactDOM from 'react-dom'
import { Sparklines, SparklinesLine } from 'react-sparklines'

class Chart extends React.Component {
  render() {
    return (
      <Sparklines data={this.props.data} width={100} height={20}>
        <SparklinesLine color="#fff" style={{ fill: "none" }} />
      </Sparklines>
    )
  }
}

export default Chart
