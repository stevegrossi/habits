import React from 'react'
import ReactDOM from 'react-dom'
import Request from '../Request'
import Icon from './Icon'

class Achievement extends React.Component {

  isCompleted() {
    const { value, threshold } = this.props.achievement
    return value >= threshold
  }

  classNames() {
    const names = ['Achievement']
    if (this.isCompleted()) {
      names.push('Achievement--completed')
    }
    return names.join(' ')
  }

  percentCompleted() {
    return Math.floor(this.props.achievement.value / this.props.achievement.threshold * 100)
  }

  render() {
    return (
      <li className={this.classNames()}>
        <div className="Achievement-iconContainer">
          <Icon className="Achievement-icon" name="achievement" />
          {!this.isCompleted() &&
            <div className="Achievement-iconOverlay">
              <span className="fs-l">{this.percentCompleted()}</span>%
            </div>
          }
        </div>
        <div className="Achievement-text">{this.props.achievement.name}</div>
      </li>
    )
  }
}

export default Achievement
