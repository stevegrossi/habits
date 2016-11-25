import React from "react"
import ReactDOM from "react-dom"

class HelloWorld extends React.Component {
  render() {
    return (
      <h2>Hello Worlds!</h2>
    )
  }
}

ReactDOM.render(
  <HelloWorld/>,
  document.getElementById("hello-world")
)
