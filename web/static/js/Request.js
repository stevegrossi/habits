import Auth from "./Auth"

const Request = {

  get: function(endpoint) {
    return fetch(endpoint, {
      credentials: 'include',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': `Token token="${Auth.token()}"`
      },
    }).then(function(response) {
      return response.json()
    }).catch(function(error) {
      console.error('Request error:', error)
    })
  },

  post: function(endpoint, data = {}, authenticated = true) {
    let headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    }
    if (authenticated) {
      headers['Authorization'] = `Token token="${Auth.token()}"`
    }

    return fetch(endpoint, {
      credentials: 'include',
      method: 'post',
      headers: headers,
      body: JSON.stringify(data)
    }).then(function(response) {
      return response.json()
    }).catch(function(error) {
      console.error('Request error:', error)
    })
  },

  delete: function(endpoint) {
    return fetch(endpoint, {
      credentials: 'include',
      method: 'delete',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': `Token token="${Auth.token()}"`
      },
    }).then(function(response) {
      if (response.bodyUsed) {
        return response.json()
      } else {
        return response
      }
    }).catch(function(error) {
      console.error('Request error:', error)
    })
  },
}

export default Request
