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

  render() {
    return (
      <div>
        <h2 className="h2 ta-c">Achievements</h2>
        <ul className="AchievementList">
          {this.state.achievements && this.state.achievements.map((achievement) =>
            <Achievement key={achievement.name} achievement={achievement} />
          )}
        </ul>
      </div>
    )
  }
}

export default AchievementList
