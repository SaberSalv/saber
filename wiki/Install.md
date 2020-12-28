Install
========

> [Wiki](Home) ▸ **Install**

### Install Ruby 1.9.3

**ArchLinux**

	$ pacman -S ruby

**Mac OS X**

Follow [Install Ruby 1.9.3 on Snow Leopard, Lion, and Mountain Lion](http://www.moncefbelyamani.com/how-to-install-xcode-homebrew-git-rvm-ruby-on-mac/)

### Install saber-upload

It use firefox to do the job.

	$ [sudo] gem install saber
	$ pacman -S firefox

### Install saber-fetch

	$ [sudo] gem install saber
	$ pacaur -S aria2

Setup ftp in server side.

Edit ~/.netrc at client side for ftp authenticate.

	machine seedbox
		login x
		password y
		
Configure rtorrent with XMLRPC at [here](http://libtorrent.rakshasa.no/wiki/RTorrentXMLRPCGuide)

Edit ~/.rtorrent.rc at server side.

	method.set_key = event.download.finished, saber-fetch, "execute= saber-drb_add, (d.get_hash), (d.get_custom1)"

Install rutorrent-saber plugin

	$ git clone https://github.com/SaberSalv/saber.git
	$ cp -r saber/rutorrent RUTORRENT/plugins/saber

### Install saber-tasks

	$ [sudo] gem install saber
	$ pacman -S mktorrent openssh rsync
