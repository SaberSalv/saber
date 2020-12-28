describe "A.RSSImg", ->
  describe ".create_ele", ->
    it "works", ->
      img = A.RSSImg.create_ele("url", 0)

      expect(img.outerHTML()).toEqual """<img class="rssimg" src="unicon0">"""
      expect(img.data()).toEqual { 
        checked: false, 
        index: 0, 
        url: "base_url/php/addtorrent.php",
        method: "post",
        params: {label: "label0", url: "url"} }

