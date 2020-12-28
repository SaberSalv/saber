jasmine.getFixtures().fixturesPath = "/spec/fixtures"

$.fn.outerHTML = ->
  $(this).clone().wrap('<div></div>').parent().html()

A.Rc.base_url = "base_url"
A.Rc.username = "username"
A.Rc.password = "password"
A.Rc.counts = 2
A.Rc.labels = ["label0", "label1"]
A.Rc.unchecked_icons = [ "unicon0", "unicon1"]
A.Rc.checked_icons = [ "icon0", "icon1"]
