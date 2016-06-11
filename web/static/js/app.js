let App = {

  redirectToToday: function() {
    let today = new Date();
    let year = today.getFullYear();
    let month = today.getMonth() + 1;
    let day = today.getDate();

    if (window.location.pathname == '/habits') {
      window.location = '/' + [year, month, day].join('/')
    }
  }
}

App.redirectToToday();

export default App
