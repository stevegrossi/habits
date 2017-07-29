import Auth from "./Auth"

const Request = {

  get: function(endpoint) {
    return fetch(endpoint, {
      method: 'GET',
      headers: this.headers()
    }).then(function(response) {
      return response.json()
    }).catch(function(error) {
      console.error('Request error:', error)
    })
  },

  post: function(endpoint, data = {}, authenticated = true) {
    return fetch(endpoint, {
      method: 'POST',
      headers: this.headers(authenticated),
      body: JSON.stringify(data)
    }).then(function(response) {
      return response.json()
    }).catch(function(error) {
      console.error('Request error:', error)
    })
  },

  patch: function(endpoint, data = {}, authenticated = true) {
    return fetch(endpoint, {
      method: 'PATCH',
      headers: this.headers(authenticated),
      body: JSON.stringify(data)
    }).then(function(response) {
      return response.json()
    }).catch(function(error) {
      console.error('Request error:', error)
    })
  },

  delete: function(endpoint) {
    return fetch(endpoint, {
      method: 'DELETE',
      headers: this.headers()
    }).then(function(response) {
      return response.json()
    }).catch(function(error) {
      console.error('Request error:', error)
    })
  },

  headers: function(authenticated = true) {
    let headers  = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    }
    if (authenticated) {
      headers['Authorization'] = `Token token="${Auth.token()}"`
    }
    return headers
  }
}

export default Request
