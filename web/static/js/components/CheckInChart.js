import React from 'react'
import ReactDOM from 'react-dom'
import { parse, getISOWeek } from 'date-fns'
import { Sparklines, SparklinesLine, SparklinesSpots } from 'react-sparklines'

class CheckInChart extends React.Component {

  processCheckInDates() {
    const data = this.props.data.reduce((result, dateString) => {
      const date = parse(dateString)
      const key = [dateString.substring(0, 4), getISOWeek(date)].join('|')
      if (!result.hasOwnProperty(key)) result[key] = 0
      result[key] += 1
      return result
    }, {})
    return Object.values(data)
  }

  spotColors() {
    return {
      '-1': 'rgba(255,255,255,.5)',
      '0': 'rgba(255,255,255,.75)',
      '1': 'rgba(255,255,255,1)'
    }
  }

  render() {
    return (
      <div>
        <Sparklines data={this.processCheckInDates()} limit={50} width={100} height={25}>
          <SparklinesLine color="#fff" style={{ fill: "none" }} />
          <SparklinesSpots size={1} spotColors={this.spotColors()} />
        </Sparklines>
      </div>
    )
  }
}

export default CheckInChart
