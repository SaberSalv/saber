pd = function(){ console.log.apply(console, arguments) }

if(plugin.canChangeMenu())
{
	theWebUI.saberFetch = function(id){
    theWebUI.perform("saberFetch");
  }

	plugin.createMenu = theWebUI.createMenu;
	theWebUI.createMenu = function( e, id )
	{
		plugin.createMenu.call(this, e, id);
		if (plugin.enabled)
		{
      theContextMenu.add(["Saber Fetch", "theWebUI.saberFetch('"+id+"')"]);
		}
	}
}

rTorrentStub.prototype.saberFetch = function()
{
  var cmd = new rXMLRPCCommand("execute");
  cmd.addParameter("string", "saber-drb_add");
  cmd.addParameter("string", this.hashes.join(","));
  cmd.addParameter("string", "saber");
  this.commands.push(cmd);
}
