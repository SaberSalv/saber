`// ==UserScript==
// @name          saber-addtorrent
// @description   add a torrent file to rutorrent from a PT site.
// @version       1.3.2
// @author        Saber
// @namespace     sabersalv
// @updateURL     http://downloads.saber.li/saber/saber-addtorrent.meta.js
// @icon          http://i.imgur.com/xEjOM.png
//
// @require       https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js
// @require       https://raw.github.com/gist/2625891/waitForKeyElements.js
// @require       https://raw.github.com/sizzlemctwizzle/GM_config/master/gm_config.js
//
// @include       *://*what.cd/torrents.php*
// @include       *://*what.cd/collages.php*
// @include       *://*what.cd/artist.php*
//
// @match         *://broadcasthe.net/torrents.php*
// @match         *://broadcasthe.net/collages.php*
// @match         *://broadcasthe.net/series.php*
// @match         *://broadcasthe.net/snatchlist.php*
//
// @include       *://*passthepopcorn.me/torrents.php*
// @include       *://*passthepopcorn.me/collages.php*
// @include       *://*passthepopcorn.me/bookmarks.php
//
// @match         *://sceneaccess.eu/browse*
// @match         *://sceneaccess.eu/spam*
// @match         *://sceneaccess.eu/archive*
// @match         *://sceneaccess.eu/foreign*
// @match         *://sceneaccess.eu/xxx*
// @match        *://sceneaccess.eu/details*
//
// @match         http://bibliotik.org/torrents/*
// @match         http://bibliotik.org/collections/*
// @match         http://bibliotik.org/publishers/*/torrents/*
// @match         http://bibliotik.org/creators/*/torrents/*
// @match         http://bibliotik.org/tags/*/torrents
// @match         http://bibliotik.org/torrents?search*
//
// @match         http://animebyt.es/torrents.php*
// @match         http://animebyt.es/torrents2.php*
// @match         http://animebyt.es/collage.php*
// @match         http://animebyt.es/series.php*
//
// @match         https://baconbits.org/torrents.php*
// @match         https://baconbits.org/top10.php
//
// @match         https://stopthepress.es/torrents.php*
// @match         https://stopthepress.es/collages.php*
// @match         https://stopthepress.es/artist.php*
//
// @match         http://thepiratebay.se/browse/*
// @match         http://thepiratebay.se/torrent/*
//
// @match         http://www.demonoid.me/files/*
// @match         http://www.demonoid.me/top_torrents.php
//
// @include       http://*d-addicts.com/forum/torrents.php*
// @include       http://*d-addicts.com/forum/viewtopic*
// ==/UserScript==
`
# <img data-checked="false" data-url="http://host/add" data-method="post" data-params="x" data-index="0" />

pd = ()-> console.log.apply(console, arguments) 
debug = ()-> console.log.apply(console, arguments) 
puts = ()-> console.log.apply(console, arguments)

class Saber
  @DEBUG = true
  @Rc = {}
  @STYLE = """
img.rssimg { 
  cursor: pointer; 
}
  """
  @GM_CONFIG_STYLE = """
#GM_config .config_var span { 
  width: 25%; 
}

#GM_config .config_var input {
  width: 75%;
}
  """
  
  @fire: ->
    setting = $("<button>saber-addtorrent configuration</button>") 
    setting.appendTo($("body"))
    setting.bind "click", ->
      GM_config.open()

A = Saber

GM_config.init "Saber Addtorrent Configuration", 
  {
    base_url: {
      label: "Base URL", type: "text", default: "http://localhost/rutorrent", title: "rutorrent url",
      section: ["rutorrent setting"] }
    username: {label: "username", type: "text", default: "foo", title: "username for login rutorrent"}
    password: {label: "password", type: "text", default: "bar", title: "password for login rutorrent"}

    counts: {
      label: "Counts", type: "int", default: 2, title: "number of addtorrent icons",
      section: ["main setting", "seperate value by comma"] 
    }
    labels: {label: "Labels", type: "text", default: "saber, saber1", title: "add to rutorrent under the label"}
    unchecked_icons: {label: "Unchecked Icons", type: "text",  default: "http://i.imgur.com/C8xAX.png, http://i.imgur.com/C8xAX.png", title: "icon for uncheched"}
    checked_icons: {label: "Checked Icons", type: "text", default: "http://i.imgur.com/Obx5Y.png, http://i.imgur.com/Obx5Y.png", title: "icon for checked"} 

    bib_rsskey: {label: "BIB rsskey", type: "text", title: "rsskey at BIB"}
  },
  A.GM_CONFIG_STYLE

A.Rc.base_url = GM_config.get("base_url")
A.Rc.username = GM_config.get("username")
A.Rc.password = GM_config.get("password")
A.Rc.counts = GM_config.get("counts")
A.Rc.labels = GM_config.get("labels").split(/[ ]*, */).reverse()
A.Rc.unchecked_icons = GM_config.get("unchecked_icons").split(/[ ]*, */).reverse()
A.Rc.checked_icons = GM_config.get("checked_icons").split(/[ ]*, */).reverse()
A.Rc.bib_rsskey = GM_config.get("bib_rsskey")
