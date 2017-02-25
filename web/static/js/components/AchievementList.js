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
    Request.get('/api/v1/account/achievements').then(function(json) {
      self.setState({
        achievements: json.achievements
      })
    })
  }

  render() {
    return (
      <ul className="AchievementList">
        {this.state.achievements && this.state.achievements.map((achievement) =>
          <Achievement key={achievement.name} achievement={achievement} />
        )}
      </ul>
    )
  }
}

export default AchievementList
