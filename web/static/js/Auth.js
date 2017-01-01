const Auth = {

  login: function(email, password) {
    return fetch('/api/v1/sessions', {
      method: 'post',
      credentials: 'include',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        account: {
          email: email,
          password: password
        }
      })
    })
    .then(function(response) {
      return response.json()
    }).then(function(json) {
      const token = json.data.token
      localStorage.setItem('token', token)
    })
  },

  logout: function() {
    // destroy token on server
    localStorage.removeItem('token')
    return true
  },

  token: function() {
    return localStorage.getItem('token')
  },

  isLoggedIn: function() {
    return !!this.token()
  }
}

export default Auth
