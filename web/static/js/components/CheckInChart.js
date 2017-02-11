import React from 'react'
import ReactDOM from 'react-dom'
import { parse, getYear, getISOWeek, format } from 'date-fns'
import { Sparklines, SparklinesLine, SparklinesSpots } from 'react-sparklines'

class CheckInChart extends React.Component {

  processCheckInDates() {
    const dateStrings = this.props.data
    const earliestDate = parse(dateStrings[0])
    const now = new Date();
    const checkInData = {};

    for (var d = earliestDate; d <= now; d.setDate(d.getDate() + 1)) {
      const week = [getYear(d), getISOWeek(d)].join(':')
      if (!checkInData.hasOwnProperty(week)) checkInData[week] = 0
      if (dateStrings.includes(format(d, 'YYYY-MM-DD'))) {
        checkInData[week] += 1
      }
    }
    return Object.values(checkInData)
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
      <figure className="CheckInChart">
        <Sparklines data={this.processCheckInDates()} width={100} height={30}>
          <SparklinesLine color="#fff" style={{ fill: "none" }} />
          <SparklinesSpots size={1} spotColors={this.spotColors()} />
        </Sparklines>
        <figcaption className="CheckInChart-caption">All-time weekly check-ins</figcaption>
      </figure>
    )
  }
}

export default CheckInChart
