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

  render() {
    const { achievement } = this.props;
    return (
      <li className={this.classNames()}>
        <Icon className="Achievement-icon" name="achievement" />
        <div className="Achievement-text">
          <div><strong>{achievement.name}</strong></div>
          <div>{achievement.description}</div>
          {!this.isCompleted() &&
            <div>{Math.floor(achievement.value / achievement.threshold * 100)}% Complete</div>
          }
        </div>
      </li>
    )
  }
}

export default Achievement
