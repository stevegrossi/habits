import React from "react"
import ReactDOM from "react-dom"
import { Router, Route, hashHistory } from 'react-router'
import HomePage from './HomePage'
import MyAccount from './MyAccount'

class Main extends React.Component {

  render() {
    return (
      <Router history={hashHistory}>
        <Route path="/" component={HomePage}/>
        <Route path="/me" component={MyAccount}/>
      </Router>
    )
  }
}

export default Main
