import React from "react"
import ReactDOM from "react-dom"
import md5 from "blueimp-md5"

class Gravatar extends React.Component {

  srcURL() {
    return `http://www.gravatar.com/avatar/${md5(this.props.email)}?s=${this.props.size}`
  }

  render() {
    return (
    <img className="Avatar" src={this.srcURL()} />
    )
  }
}

export default Gravatar
