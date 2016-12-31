import React from "react"
import ReactDOM from "react-dom"
import { browserHistory } from 'react-router'
import Auth from '../Auth'

class LoginForm extends React.Component {

  constructor(props) {
    super(props)
    this.state = { error: false }
  }

  handleSubmit(event) {
    event.preventDefault()
    const { email, password } = this.refs
    if (Auth.login(email.value, password.value)) {
      browserHistory.push('/habits')
    } else {
      this.setState({ error: true })
    }
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit.bind(this)}>
        {this.state.error &&
          <p>There was a problem!</p>
        }
        <label htmlFor="login-email">Email</label>
        <input ref="email" type="email" id="login-email" className="TextInput" />

        <label htmlFor="login-password">Password</label>
        <input ref="password" type="password" id="login-password" className="TextInput" />

        <input type="submit" value="Log In" className="Button" />
      </form>
    )
  }
}

export default LoginForm
