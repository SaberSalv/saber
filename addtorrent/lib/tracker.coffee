class A.Base
  @SELECTOR = "body"
  @SEPERATOR = ""

  @inject: ->
    img = new this
    img.inject()
    img.fire()

  # callback(e, link|id)
  scan: (callback)->
    $(@constructor.SELECTOR).each ->
      callback.call null, $(this), this.href

  inject: ->
    @scan (e, link) =>
      @inject_rssimg(e, link)

  inject_rssimg: (e, id)->
    for i in [0...A.Rc.counts]
      link = @build_link(id)
      rssimg = @create_ele(link, i)
      e.after(rssimg)
      rssimg.before(@constructor.SEPERATOR)

  fire: ->
    $("img.rssimg").live "click.saber", (e) =>
      img = $(e.target)
      index = img.data("index")
      if img.data("checked") then checked="uncheck" else checked="check"
      debug "click #{checked}" if A.DEBUG

      if img.data("checked")
        img.data "checked", false
        img.attr "src", A.Rc.unchecked_icons[index]

      else
        settings = 
          url: img.data("url")
          method: img.data("method")
          data: img.data("params")
          headers: {"Content-Type": "application/x-www-form-urlencoded"}
          user: A.Rc.username
          password: A.Rc.password
          #ignoreRedirect: true
          onload: (rep)->
            if rep.responseText.match(/addTorrentFailed/)
              alert "saber-addtorrent failed."

        @request(settings)
      
        img.data "checked", true
        img.attr "src", A.Rc.checked_icons[index]
        
      false

  request: (settings) ->
    debug "request", settings if A.DEBUG
    settings["data"] = $.param(settings["data"])
    GM_xmlhttpRequest settings

  create_ele: (url, index)->
    $ "<img>", 
      src: A.Rc.unchecked_icons[index]
      class: "rssimg"
      data: 
        checked: false
        index: index
        url: "#{A.Rc.base_url}/php/addtorrent.php"  
        method: "post"
        params: {label: A.Rc.labels[index], url: url}

  build_link: (link)->
    link

# a Gazelle base class
class A.Gazelle extends A.Base
  @SELECTOR = "a[title='Download']"
  @SEPERATOR = " | "

# what.cd
class A.What extends A.Gazelle

# Broadcast.the
class A.BTN extends A.Gazelle
  @SEPERATOR = ""

  constructor: ->
    super
    [_, @passkey, @authkey] = $("link[href*='authkey']")[0].href.match(/passkey=([^&]+)&authkey=([^&]+)/)

  scan: (callback)->
    $(@constructor.SELECTOR).each ->
      id = this.href.match(/id=(\d+)/)[1]
      callback.call null, $(this), id

  inject: ->
    if not location.pathname.match(/snatchlist.php/)
      @scan (e, link) =>
        @inject_rssimg(e, link)

    ###
    # Torrent History
    waitForKeyElements "td[id^=hnr]", (e)=>
      id = e.attr("id").match(/hnr(\d+)/)[1]
      @inject_rssimg(e, id)
      false
    ###

  build_link: (id)->
    "#{location.protocol}//#{location.host}/torrents.php?action=download&id=#{id}&authkey=#{@authkey}&torrent_pass=#{@passkey}"

# PassThePopcorn
class A.PTP extends A.Gazelle

# animebytes
class A.AB extends A.Gazelle

# baconBITS
class A.BB extends A.Gazelle

# bliotik
class A.BIB extends A.Gazelle
  @SEPERATOR = ""

  constructor: ->
    super
    #@rsskey = $("link[href*='rsskey']")[0].href.match(/rsskey=([^&]+)/)[1]

  scan: (callback)->
    $(@constructor.SELECTOR).each ->
      id = this.href.match(/torrents\/([^/]+)/)[1]
      callback.call null, $(this), id

  build_link: (id)->
    "#{location.protocol}//#{location.host}/rss/download/#{id}?rsskey=#{A.Rc.bib_rsskey}"

# SceneAccess.org
class A.SCC extends A.Base
  @SELECTOR = "a[href^='download/']"

# StopThePress
class A.STP extends A.Gazelle

# thepriatebay
class A.TPB extends A.Base
  @SELECTOR = "a[href^='magnet:']"

# demonoid
class A.Demonoid extends A.Base
  @SELECTOR = "a[href^='/files/downloadmagnet/']"

  request: (settings) ->
    debug "request", settings if A.DEBUG
    GM_xmlhttpRequest
      url: settings["data"]["url"]
      method: "GET"
      failOnRedirect: true
      onreadystatechange: (resp) =>
        if resp.status == 302
          settings["data"]["url"] = resp.responseHeaders.match(/Location: ([^\n]*\n)/)[1]
          debug "location #{settings["data"]["url"]}" if A.DEBUG

          settings["data"] = $.param(settings["data"])
          GM_xmlhttpRequest settings

class A.DAddicts extends A.Base
  @SELECTOR = "a[href^='magnet:']"
