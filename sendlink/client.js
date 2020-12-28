/* Depends: XMLHttpRequest, lodash.js, klass.js, ui.js
 *
 * USAGE:
 *
 *  Client.add({type: "Aria2", url: "http://localhost"}, "http://exampe.com/index.html", {
 *    directory: "/Downloads"
 *  })
 *
 */

var Client = klass({
  initialize: function(client, link, options) {
    this.client = client
    this.link = link
    this.options = options || {}
  },

  headers: {},

  getParams: function() {
    return this.options.test ? this.testParams() : this.params()
  },

  params: function() {
    return ""
  },

  testParams: function() {
    return ""
  },

  request: function() {
    var self = this
    var xhr = new XMLHttpRequest()
    xhr.open("POST", this.url(), true, this.client.username, this.client.password)
    _.forEach(this.headers, function(value, header) {
      xhr.setRequestHeader(header, value)
    })
    xhr.onreadystatechange = function() {
      self.response(this)
    }
    return xhr
  },

  notifySuccess: function(message) {
    if (this.options.test) {
      this.options.testSuccess(message)
    } else {
      ui.notify(`Added to ${this.client.name} Success`)
    }
  },

  notifyFailed: function(message) {
    if (this.options.test) {
      this.options.testFailed(message)
    } else {
      ui.notify(`Added to ${this.client.name} Failed: ${message}`)
    }
  }
})

Client.add = function(client, link, options) {
  ui.debug("Client.add(client, link, options)", client, link, options)
  var c = new Client.Clients[client.type](client, link, options)
  c.request()
}

Client.Clients = {}
var ClientJSON = Client.extend({
  request: function() {
    var xhr = this.supr()
    xhr.setRequestHeader("Content-Type", "application/json")
    xhr.send(JSON.stringify(this.getParams()))
  },

  // JSON-RPC 2.0: http://www.jsonrpc.org/specification
  response: function(xhr) {
    if (xhr.readyState === 4) {
      if (xhr.status === 200) {
        var res = JSON.parse(xhr.responseText)
        if (res.error) {
          this.notifyFailed(res.error.message)
        } else {
          this.notifySuccess(res.result)
        }
      } else {
        this.notifyFailed(`${xhr.status} ${xhr.statusText}`)
      }
    }
  }
})

var ClientForm = Client.extend({
  request: function() {
    var xhr = this.supr()
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
    var params = new FormData()
    _.forEach(this.getParams(), function(v, k) {
      params.append(k, v)
    })
    xhr.send(params)
  }
})

// API: http://aria2.sourceforge.net/manual/en/html/aria2c.html#rpc-interface
var Aria2 = ClientJSON.extend({
  url: function() {
    var a = new URL(this.client.url)
    a.port = a.port === "" ? "6800" : a.port
    a.pathname = a.pathname === "/" ? "/jsonrpc" : a.pathname
    return a.href
  },

  params: function() {
    var params = [
      [this.link],
      {
        dir: this.options.directory
      }
     ]
    return { method: "aria2.addUri", params: params, id: 1, jsonrpc: "2.0" }
  },

  testParams: function() {
    return { method: "aria2.getVersion", id: 1, jsonrpc: "2.0" }
  }
})
Client.Clients["Aria2"] = Aria2

// API: https://trac.transmissionbt.com/browser/trunk/extras/rpc-spec.txt
var Transmisson = ClientJSON.extend({
  url: function() {
    var a = new URL(this.client.url)
    a.port = a.port === "" ? "9091" : a.port
    a.pathname = a.pathname === "/" ? "/transmission/rpc" : a.pathname
    return a.href
  },

  params: function() {
    var params = {
      "filename": this.link,
      "download-dir": this.options.directory
    }
    return { method: "torrent-add", arguments: params }
  },

  testParams: function() {
    return { method: "session-get" }
  },

  response: function(xhr) {
    if (xhr.readyState === 4) {
      if (xhr.status === 200) {
        var res = JSON.parse(xhr.responseText)
        if (res.result === "success") {
          this.notifySuccess()
        } else {
          this.notifyFailed(res["result"])
        }
      } else if (xhr.status === 409) {
        this.headers["X-Transmission-Session-Id"] = xhr.getResponseHeader("X-Transmission-Session-Id")
        this.request()
      } else {
        this.notifyFailed(`${xhr.status} ${xhr.statusText}`)
      }
    }
  }
})
Client.Clients["Transmisson"] = Transmisson

var Rutorrent = ClientForm.extend({
  url: function() {
    var a = this.client.url
    a.pathname = a.pathname === "/" ? "/php/addtorrent.php" : a.pathname
    return a.href
  },

  params: function() {
    //"label", this.client.labels[index])
    return { url: this.link }
  },

  response: function(xhr) {
    if (xhr.readyState === 4) {
      if (xhr.status === 200) {
        if (xhr.responseText.match(/addTorrentFailed/)) {
          this.notifyFailed()
        } else {
          this.notifySuccess()
        }
      } else {
        this.notifyFailed(`${xhr.status} ${xhr.statusText}`)
      }
    }
  }
})
// Not Ready
//Client.Clients["Rutorrent"] = Rutorrent
