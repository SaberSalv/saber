var pd = console.log.bind(console)
var rc = {}

var clientAdd = function(client, options) {
  Client.add(client, rc.link, options)
}

var openAddDialog = function(url, preferDir) {
  rc.link = url
  rc.preferDir = preferDir
  var width = 847, height = 253, left = Math.round((screen.width/2)  - (width/2)), top = Math.round((screen.height/2) - (height/2))
  chrome.windows.create({ url: "add-dialog.html", type: "popup", width: width, height: height, left: left, top: top })
}

/*
 * Main
 */

chrome.contextMenus.create({
  title: "Add to Aria2",
  id: "default",
  contexts: ["link"]
})

chrome.contextMenus.onClicked.addListener(function(info, tab) {
  openAddDialog(info.linkUrl)
})

chrome.runtime.onMessage.addListener(function(request) {
  pd('request', request)
  if (request.type === "add") {
    openAddDialog(request.link, request.preferDir)
  }
})
