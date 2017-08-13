import React from 'react'
import ReactDOM from 'react-dom'
import { parse, getYear, getISOWeek, format } from 'date-fns'
import { Sparklines, SparklinesLine, SparklinesSpots } from 'react-sparklines'

class CheckInChart extends React.Component {

  spotColors() {
    return {
      '-1': 'rgba(255,255,255,.5)',
      '0': 'rgba(255,255,255,.75)',
      '1': 'rgba(255,255,255,1)'
    }
  }

  render() {
    return (
      <figure className="CheckInChart">
        <Sparklines data={this.props.data} width={100} height={30} min={0}>
          <SparklinesLine color="#fff" />
          <SparklinesSpots size={1} spotColors={this.spotColors()} />
        </Sparklines>
        <figcaption className="CheckInChart-caption">All-time weekly check-ins</figcaption>
      </figure>
    )
  }
}

export default CheckInChart
