import React from "react"
import ReactDOM from "react-dom"
import { Link } from 'react-router'

class HomePage extends React.Component {

  render() {
    return (
      <div>
        <h2>Welcome to Habits!</h2>
        <p className="lead">An app to help you keep good habits.</p>
        <p><Link to="/register" className="Button">Register</Link></p>
      </div>
    )
  }
}

export default HomePage
