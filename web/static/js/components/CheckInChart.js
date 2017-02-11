import React from 'react'
import ReactDOM from 'react-dom'
import { parse, getYear, getISOWeek } from 'date-fns'
import { Sparklines, SparklinesLine, SparklinesSpots } from 'react-sparklines'

class CheckInChart extends React.Component {

  processData() {
    const dateStrings = this.props.data
    const dates = dateStrings.map((dateString) => parse(dateString))
    const data = {}
    dates.forEach((date) => {
      const key = [getYear(date), getISOWeek(date)].join('|')
      if (typeof data[key] == 'undefined') {
        data[key] = 0
      }
      data[key] += 1
    })
    return Object.values(data)

    // var groupBy = function(xs, key) {
    //   return xs.reduce(function(rv, x) {
    //     (rv[x[key]] = rv[x[key]] || []).push(x);
    //     return rv;
    //   }, {});
    // };
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
        <Sparklines data={this.processData()} limit={50} width={100} height={25}>
          <SparklinesLine color="#fff" style={{ fill: "none" }} />
          <SparklinesSpots size={1} spotColors={this.spotColors()} />
        </Sparklines>
      </div>
    )
  }
}

export default CheckInChart
