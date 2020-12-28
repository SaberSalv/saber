var DEBUG = true
//var DEBUG_NO_CLOSE_WINDOW = true
var DEBUG = null
var DEBUG_NO_CLOSE_WINDOW = null

var UI = klass({
  echo: function() {
    console.log.apply(console, arguments)
  },

  debug: function() {
    if (DEBUG) {
      this.echo.apply(this, arguments)
    }
  },

  notify: function(msg) {
    chrome.notifications.create("", {
      type: "basic",
      title: "Saber Sendlink",
      message: msg,
      iconUrl: "images/icon128.png"
    }, function() { })
  }
})

var ui = new UI()
