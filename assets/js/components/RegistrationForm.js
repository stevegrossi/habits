import React from 'react'
import ReactDOM from 'react-dom'
import { browserHistory } from 'react-router'
import Request from '../Request'
import Auth from '../Auth'

class RegistrationForm extends React.Component {

  constructor(props) {
    super(props)
    this.state = { error: false }
  }

  handleSubmit(event) {
    event.preventDefault()
    const self = this
    const { email, password } = this.refs
    const data = {
      account: {
        email: email.value,
        password: password.value
      }
    }
    Request.post('/api/v1/accounts', data, false)
      .then(function(json) {
        Auth.saveToken(json.data.token)
        browserHistory.push('/habits')
      })
      .catch(function(error) {
        console.log(error)
        self.setState({ error: true })
      })
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit.bind(this)}>
        {this.state.error &&
          <p>There was a problem.</p>
        }
        <label htmlFor="registration-email">Email</label>
        <input ref="email" type="email" id="registration-email" className="TextInput" required autoFocus />

        <label htmlFor="registration-password">Password</label>
        <input ref="password" type="password" id="registration-password" className="TextInput" required />

        <input type="submit" value="Register" className="Button" />
      </form>
    )
  }
}

export default RegistrationForm
