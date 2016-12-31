import React from "react"
import ReactDOM from "react-dom"
import { Router, Route, IndexRoute, hashHistory } from 'react-router'
import Layout from './Layout'
import HomePage from './HomePage'
import MyAccount from './MyAccount'
import RegistrationForm from './RegistrationForm'
import LoginForm from './LoginForm'
import AllHabits from './AllHabits'

class App extends React.Component {

  requireAuth(nextState, replace) {
    if (true) {
      replace({ pathname: '/login' })
    }
  }

  render() {
    return (
      <Router history={hashHistory}>
        <Route path="/" component={Layout}>
          <IndexRoute component={HomePage}/>
          <Route path="/register" component={RegistrationForm} />
          <Route path="/login" component={LoginForm} />
          <Route path="/me" component={MyAccount} onEnter={this.requireAuth} />
          <Route path="/habits" component={AllHabits} onEnter={this.requireAuth} />
        </Route>
      </Router>
    )
  }
}

export default App
