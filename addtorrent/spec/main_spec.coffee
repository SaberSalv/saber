describe "main", ->
  SITES = [ 
    ["what.cd", A.What],
    ["broadcasthe.net", A.BTN],
    ["passthepopcorn.me", A.PTP],
    ["sceneaccess.org", A.SCC],
    ["bibliotok.org", A.BIB],
    ["animebyt.es", A.AB],
    ["baconbits.org", A.BB],
    ["thepriatebay.se", A.TPB],
    ["demonoid.me", A.Demonoid] ]

  for [host, tracker_klass] in SITES
    it "inject at #{host}", ->
      spyOn tracker_klass, "inject"
      inject(host)
      expect(tracker_klass["inject"]).toHaveBeenCalled()
