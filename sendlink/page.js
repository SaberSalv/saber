var rc = null,
    ui = null,
    storage = chrome.storage.sync
var pd = console.log.bind(console)
var DEBUG = true

var UI = klass({
  echo: function() {
    console.log.apply(console, arguments)
  },

  debug: function() {
    if (DEBUG) {
      this.echo.apply(this, arguments)
    }
  }
})

/*
 *
 *  SELECTOR: "a[title='Download']",
 *  SEPERATOR: " | ",
 *
 *  inject: function() {
 *    scan(function(el, link) {
 *      injectIcon(el, id)
 *        buildLink(id)
 *
 */
var Site = klass({
  SELECTOR: "",
  SEPERATOR: "",
  preferDir: "",

  run: function() {
    ui.debug("scan", this.SELECTOR, $(this.SELECTOR).length)
    this.inject()

    var self = this
    $("body").on("click", ".saber-sendlink-icon", function(e) {
      self.add(e.target.dataset.link)
      return false
    })
  },

  inject: function() {
    var self = this
    this.scan(function(e, link) {
      self.injectIcon(e, link)
    })
  },

  // callback(e, link|id)
  scan: function(callback) {
    var self = this
    $(this.SELECTOR).each(function() {
      callback.call(null, $(this), this.href)
    })
  },

  injectIcon: function(e, id) {
    var link = this.buildLink(id)
    var icon = this.createIcon(link)
    e.after(icon)
    $(icon).before(this.SEPERATOR)
  },

  buildLink: function(link) {
    return link
  },

  add: function(link) {
    ui.debug("Add: ", link)
    chrome.runtime.sendMessage({type: "add", link: link, preferDir: this.preferDir})
  },

  createIcon: function(url) {
    var icon = document.createElement("img")
    icon.src = chrome.runtime.getURL("images/icon16.png")
    icon.className = "saber-sendlink-icon"
    icon.dataset.link = url
    return icon
  }
})
Site.Sites = []

var Gazelle = Site.extend({
  SELECTOR: "a[title='Download']",
  SEPERATOR: " | "
})

var What = Gazelle.extend({
  SELECTOR: "a:contains('DL')",
  preferDir: "Music"
})
Site.Sites.push([/what\.cd$/, What])

var Broadcasthe = Gazelle.extend({
  SEPERATOR: "",
  preferDir: "TVShows",

  initialize: function() {
    var auth = $("link[href*='authkey']")[0].href.match(/passkey=([^&]+)&authkey=([^&]+)/)
    this.passkey = auth[1]
    this.authkey = auth[2]
  },

  scan: function(callback) {
    $(this.SELECTOR).each(function() {
      //var id = this.href.match(/id=(\d+)/)[1]
      var id = this.href
      callback.call(null, $(this), id)
    })
  },

  inject: function() {
    var self = this
    if (!location.pathname.match(/snatchlist.php/)) {
      this.scan(function(e, id) {
        self.injectIcon(e, id)
      })
    }

    /*
    // Torrent History
    waitForKeyElements "td[id^=hnr]", (e)=>
      id = e.attr("id").match(/hnr(\d+)/)[1]
      @injectIcon(e, id)
      false
    */
  },

  buildLink: function(id) {
    return id
    //return `${location.protocol}//${location.host}/torrents.php?action=download&id=${id}&authkey=${this.authkey}&torrent_pass=${this.passkey}`
  }
})
Site.Sites.push([/broadcasthe\.net$/, Broadcasthe])

var Passthepopcorn = Gazelle.extend({
  preferDir: "Movie"
})
Site.Sites.push([/passthepopcorn\.me$/, Passthepopcorn])

var Animbytes = Gazelle.extend()
Site.Sites.push([/animebyt\.es$/, Animbytes])

var Baconbits = Gazelle.extend()
Site.Sites.push([/baconbits\.org$/, Baconbits])

var Bibliotik = Gazelle.extend({
  SEPERATOR: "",
  preferDir: "Books",

  initialize: function() {
    this.rsskey = $("link[href*='rsskey']")[0].href.match(/rsskey=([^&]+)/)[1]
  },

  scan: function(callback) {
    $(this.SELECTOR).each(function() {
      var id = this.href.match(/torrents\/([^/]+)/)[1]
      callback.call(null, $(this), id)
    })
  },

  buildLink: function(id) {
    return `${location.protocol}//${location.host}/rss/download/${id}?rsskey=${this.rsskey}`
  }
})
Site.Sites.push([/bibliotik\.org$/, Bibliotik])

var Stopthepress = Gazelle.extend({
  preferDir: "Books"
})
Site.Sites.push([/stopthepress\.es$/, Stopthepress])

var Sceneaccess = Site.extend({
  SELECTOR: "a[href^='download/']"
})
Site.Sites.push([/sceneaccess\.eu$/, Sceneaccess])

var Thepiratebay = Site.extend({
  SELECTOR: "a[href^='magnet:']"
})
Site.Sites.push([/thepiratebay\.se$/, Thepiratebay])

var Demonoid = Site.extend({
  SELECTOR: "a[href^='/files/downloadmagnet/']",

  add: function(settings) {
    ui.debug("add", settings)
    GM_xmlhttpRequest({
      url: settings["data"]["url"],
      method: "GET",
      failOnRedirect: true,
      onreadystatechange: function(resp) {
        if (resp.status === 302) {
          settings["data"]["url"] = resp.responseHeaders.match(/Location: ([^\n]*\n)/)[1]
          ui.debug("location //{settings['data']['url']}")

          settings["data"] = $.param(settings["data"])
          GM_xmlhttpRequest(settings)
        }
      }
    })
  }
})
Site.Sites.push([/demonoid\.me$/, Demonoid])

var DAddicts = Site.extend({
  SELECTOR: "a[href^='magnet:']"
})
Site.Sites.push([/d-addicts\.com$/, DAddicts])

/********
 * main
 ********/

storage.get(null, function(items) {
  rc = items
})
ui = new UI()

var found = null
Site.Sites.every(function(v) {
  if (location.hostname.match(v[0])) {
    found = v
    return false
  }
  return true
})
if (found) {
  ui.debug("found")
  new found[1]().run()
} else {
  ui.debug("not found")
}
