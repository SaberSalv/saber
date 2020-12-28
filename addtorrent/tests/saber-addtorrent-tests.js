jasmine.getFixtures().fixturesPath = "/spec/fixtures";

$.fn.outerHTML = function() {
  return $(this).clone().wrap('<div></div>').parent().html();
};

A.Rc.base_url = "base_url";

A.Rc.username = "username";

A.Rc.password = "password";

A.Rc.counts = 2;

A.Rc.labels = ["label0", "label1"];

A.Rc.unchecked_icons = ["unicon0", "unicon1"];

A.Rc.checked_icons = ["icon0", "icon1"];
describe("main", function() {
  var SITES, host, tracker_klass, _i, _len, _ref, _results;
  SITES = [["what.cd", A.What], ["broadcasthe.net", A.BTN], ["passthepopcorn.me", A.PTP], ["sceneaccess.org", A.SCC], ["bibliotok.org", A.BIB], ["animebyt.es", A.AB], ["baconbits.org", A.BB], ["thepriatebay.se", A.TPB], ["demonoid.me", A.Demonoid]];
  _results = [];
  for (_i = 0, _len = SITES.length; _i < _len; _i++) {
    _ref = SITES[_i], host = _ref[0], tracker_klass = _ref[1];
    _results.push(it("inject at " + host, function() {
      spyOn(tracker_klass, "inject");
      inject(host);
      return expect(tracker_klass["inject"]).toHaveBeenCalled();
    }));
  }
  return _results;
});
describe("A.What", function() {
  return describe("#scan", function() {
    return it("works", function() {
      var links, what;
      loadFixtures("what.html");
      links = [];
      what = new A.What();
      what.scan(function(ele, url) {
        return links.push(url);
      });
      return expect(links[0]).toContain("/torrents.php?action=download&id=");
    });
  });
});
