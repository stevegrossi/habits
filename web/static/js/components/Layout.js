import React from 'react'
import ReactDOM from 'react-dom'
import { Link } from 'react-router'
import Auth from '../Auth'

class Layout extends React.Component {

  render() {
    return (
      <div>
        <header className='AppHeader'>
          <h1 className='AppHeader-logo'>
            <Link to='/'>Habits</Link>
          </h1>
          <nav className='AppHeader-nav'>
            {Auth.isLoggedIn() &&
              <ul>
                <li><Link to="/habits">Habits</Link></li>
                <li><Link to="/me">Me</Link></li>
                <li><Link to="/logout">Log Out</Link></li>
              </ul>
            }
            {!Auth.isLoggedIn() &&
              <ul>
                <li><Link to="/login">Log In</Link></li>
              </ul>
            }
          </nav>
        </header>

        <main className='AppMain'>
          <div className='AppMain-content'>
            {this.props.children}
          </div>
        </main>

        <footer className='AppFooter'>
          <p>Make it a great day.</p>
        </footer>
      </div>
    )
  }
}

export default Layout
