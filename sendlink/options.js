var storage = chrome.storage.sync

/*
 * clients = [
 *   {name: "Aria2", url: "http://aria2.lan", default: false}
 * ]
 *
 */

var DATA_DEFAULT = {
  clients: [],
  directories: [],
}

rivets.model = {
  initialize: function(data) {
    this.data = data
    this.clientTypes = _.keys(Client.Clients)
  },

  testURL: _.throttle(function(event, view) {
    Client.add(view.client, null, {
      test: true,
      testSuccess: function(message) {
        view.client.isOnline = true
      },
      testFailed: function(message) {
        view.client.isOnline = false
      }
    })
  }, 1000),

  addClient: function() {
    this.data.clients.push({})
  },

  selectDefaultClient: function(event, view) {
    _.invoke(this.data.clients, _.set, 'default', false)
    view.client.default = true
  },

  addDirectory: function() {
    this.data.directories.push({name: "", path: ""})
  },

  selectDefaultDirectory: function(event, view) {
    _.invoke(this.data.directories, _.set, 'default', false)
    view.directory.default = true
  },

  save: function(event) {
    storage.set(this.data)
  },

  toHash: function() {
    var hash = {}
    _.forEach(this, function(v, k) {
      if (! _.isFunction(v)) {
        hash[k] = v
      }
    })
    return hash
  }
}

/*
 * main
 */

storage.get(DATA_DEFAULT, function(data) {
  rivets.model.initialize(data)
  // test each URL when first open the dialog
  _.forEach(data.clients, function(c) {
    rivets.model.testURL(null, {client: c})
  })
  rivets.bind(document.body, rivets.model)
})
