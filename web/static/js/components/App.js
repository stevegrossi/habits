import React from 'react'
import ReactDOM from 'react-dom'
import { Router, Route, IndexRoute, browserHistory } from 'react-router'
import Auth from '../Auth'
import Layout from './Layout'
import HomePage from './HomePage'
import MyAccount from './MyAccount'
import RegistrationForm from './RegistrationForm'
import LoginForm from './LoginForm'
import AllHabits from './AllHabits'
import NewHabitForm from './NewHabitForm'

class App extends React.Component {

  requireAuth(nextState, replace) {
    if (!Auth.isLoggedIn()) {
      replace({ pathname: '/login' })
    }
  }

  logOut() {
    Auth.logOut().then(function() {
      browserHistory.push('/')
    })
  }

  render() {
    return (
      <Router history={browserHistory}>
        <Route path="/" component={Layout}>
          <IndexRoute component={HomePage}/>
          <Route path="/register" component={RegistrationForm} />
          <Route path="/login" component={LoginForm} />
          <Route path="/logout" onEnter={this.logOut} />
          <Route path="/me" component={MyAccount} onEnter={this.requireAuth} />
          <Route path="/habits" component={AllHabits} onEnter={this.requireAuth} />
          <Route path="/habits/new" component={NewHabitForm} onEnter={this.requireAuth} />
        </Route>
      </Router>
    )
  }
}

export default App
