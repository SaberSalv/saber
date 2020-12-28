/*  Depends: lodash, klass, rivets, ui, client
 *
 */

var storage = chrome.storage.sync

rivets.model = {
  // data
  // client
  // directory
  // customDirectory

  initialize: function(data, bgrc) {
    this.data = data
    this.client = _.find(data.clients, "default", true)
    // handle directory
    var found = _.find(data.directories, 'name', bgrc.preferDir)
    if (found) {
      _.invoke(this.data.directories, _.set, "default", false)
      found.default = true
    }
    this.directory = _.find(data.directories, "default", true)
  },

  selectClient: function(event, view) {
    this.client = view.client
    _.invoke(this.data.clients, _.set, "default", false)
    view.client.default = true
  },

  selectDirectory: function(event, view) {
    this.directory = view.directory
    _.invoke(this.data.directories, _.set, "default", false)
    view.directory.default = true
  },

  add: function(event) {
    var self = this
    var win = window
    var options = {
      directory: _.isEmpty(this.customDirectory) ? this.directory.path : this.customDirectory
    }
    chrome.runtime.getBackgroundPage(function(window) {
      window.clientAdd(self.client, options)
      if (!DEBUG_NO_CLOSE_WINDOW) {
        win.close()
      }
    })
  }
}

// main

chrome.runtime.getBackgroundPage(function(window) {
  var bgrc = window.rc

  storage.get(null, function(data) {
    rivets.model.initialize(data, bgrc)
    rivets.bind(document.body, rivets.model)
  })
})


