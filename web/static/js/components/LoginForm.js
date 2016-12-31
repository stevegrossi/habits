import React from "react"
import ReactDOM from "react-dom"
import Auth from "../Auth"

class LoginForm extends React.Component {

  handleSubmit(event) {
    event.preventDefault()
    const { email, password } = this.refs
    Auth.login(email.value, password.value)
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit.bind(this)}>
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
