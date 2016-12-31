const Auth = {

  login: function(email, password) {
    console.log("Log In:", email, password)
    // make request
    localStorage.setItem('token', '1234')
    return true
  },

  logout: function() {
    localStorage.removeItem('token')
    return true
  },

  isLoggedIn: function() {
    return !!localStorage.getItem('token')
  }
}

export default Auth
