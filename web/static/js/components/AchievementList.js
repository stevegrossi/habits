import React from 'react'
import ReactDOM from 'react-dom'
import Request from '../Request'
import Achievement from './Achievement'

class AchievementList extends React.Component {

  constructor(props) {
    super(props)
    this.state = {
      achievements: null
    }
  }

  componentWillMount() {
    const self = this
    Request.get(this.props.endpoint).then(function(json) {
      self.setState({
        achievements: json.achievements
      })
    })
  }

  completedCount() {
    return this.state.achievements.filter((achievement) =>
      achievement.value >= achievement.threshold
    ).length;
  }

  totalCount() {
    return this.state.achievements.length;
  }

  render() {
    return (
      <div className="AchievementList">
        <h2 className="h2 ta-c">
          Achievements
          {this.state.achievements &&
            <span>&nbsp;({this.completedCount()}/{this.totalCount()})</span>
          }
        </h2>
        <ul className="AchievementList-list">
          {this.state.achievements && this.state.achievements.map((achievement) =>
            <Achievement key={achievement.name} achievement={achievement} />
          )}
        </ul>
      </div>
    )
  }
}

export default AchievementList
