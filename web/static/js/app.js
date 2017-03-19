import React from 'react'
import ReactDOM from 'react-dom'
import AllHabits from './components/AllHabits'
import App from './components/App'
import Promise from 'promise-polyfill';

// To add to window
if (!window.Promise) {
  window.Promise = Promise;
}

const habitContainer = document.getElementById('habit-container')
if (habitContainer) {
  ReactDOM.render(<AllHabits />, habitContainer)
}

const mainContainer = document.getElementById('main')
if (mainContainer) {
  ReactDOM.render(<App />, mainContainer)
}
