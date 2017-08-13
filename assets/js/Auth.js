import Request from './Request'

const Auth = {

  logIn: function(email, password) {
    const saveToken = this.saveToken
    const data = {
      account: {
        email: email,
        password: password
      }
    }
    return Request.post('/api/v1/sessions', data, false).then(function(json) {
      saveToken(json.data.token)
    })
  },

  logOut: function() {
    const endpoint = `/api/v1/sessions/${this.token()}`
    return Request.delete(endpoint).then(function() {
      localStorage.removeItem('token')
    })
  },

  saveToken: function(token) {
    localStorage.setItem('token', token)
  },

  token: function() {
    return localStorage.getItem('token')
  },

  isLoggedIn: function() {
    return !!this.token()
  }
}

export default Auth
