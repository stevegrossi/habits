const Auth = {

  login: function(email, password) {
    this.requestLogin(email, password, (token) => {
      if (token) {
        localStorage.setItem('token', token)
        return true
      } else {
        return false
      }
    })
  },

  logout: function() {
    // destroy token on server
    localStorage.removeItem('token')
    return true
  },

  isLoggedIn: function() {
    return !!localStorage.getItem('token')
  },

  requestLogin: function(email, password, callback) {
    fetch('/api/v1/sessions', {
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
      callback(json.data.token)
    }).catch(function(error) {
      console.error('Error fetching JSON:', error)
    })
  }
}

export default Auth
