TODO
-----
**News:** I'm panning to re-write it in Go language, but I don't have time for it at the moment, feedbacks and helpers are always welcome :). And I'll not add any new features in this one.

**Features:**

* **Upload**: upload a torrent file from command line to the site.
* **Fetch**: automatically/manually fetch files from seedbox to home-laptop.
* **Other Tasks**:
	- **Make**: make a torrent file and copy it to local and remote watch directory.
	- **Send**: send files from home-laptop to seedbox.
	- **Clean**: remove files which are not seeded in rtorrent.

you can find more tools at [here](https://github.com/SaberSalv/saber/wiki/Tools).

Getting Started
----------------

Create `~/.saberrc` configuration file with mode 600 from [template](https://github.com/SaberSalv/saber/blob/master/templates/_saberrc).

### Upload

Because of lacking APIs in major PT sites, so I write this small script to help uploading a torrent from cmdline. Good news is BTN v2.0 will include API. And BTN already has an official autobot which grabs scene releases. :)

> Support sites: BIB, bB, STP

> Support upload types: ebook, magazine

Manual fill \<info-data>.yml file and upload it.

	$ saber g magazine hello.pdf
	> create hello.yml
	$ edit hello.yml

		type: magazines
		title: Hello
		description: Hello World
		...

	$ saber.bib upload pdf hello.yml
	> it opens a firefox browser
	> it fills data and submit it
	> upload complete

Auto fill \<info-data>.yml file from ISBN.

	$ saber g ebook hello.epub:0439554934
	> create hello.yml

### Fetch

#### AutoFetch

Start saber-server at server side.

	$ saber server -V

Start saber-client at client side.

	$ aria2c --enable-rpc --save-session session.lock -i session.lock
	$ saber client -V

Test if it works

	(server) $ saber drb_add <rtorrent_file_hash_id> saber -V
	(client) > aria2 should begin download file from ftp://seedbox/bt/<file>

Automatically fetch: when a file is finished download in rutorrent with label 'saber', then it'll add to aria2.

Manually fetch: right click 'Saber Fetch' in rutorrent web ui, then it'll add to aria2.

Or from command line, send a download file to client: `saber drb_add <hash_id> saber`, sometime the client need a long time(2 minutes) to recive the file list sent by server.
	
#### ManualFetch

Begin fetch a file from seedbox

	$ saber fetch foo
	> begin to download ftp://seedbox/bt/foo/a.epub via aria2
	> begin to download ftp://seedbox/bt/foo/b.epub via aria2

### Tasks

#### Make

Make a torrent

	$ saber.bib make hello.epub
	> mktorrent -p -a ANNOUNCE_URL hello.epub
	> cp hello.epub.torrent ~/bt/watch 
	> rsync -Phr hello.epub.torrent user@host:bt/watch

#### Send

Send files to seedbox

	$ saber send1 hello.epub bt
	> rsync -ahP hello.epub user@host:bt

#### Clean

Clean up unseeded files in rtorrent.

	$ saber clean

Use `saber help` to list all tasks. use `saber help upload` to find specific task help.

Install
-------

_Main article_: [Install Saber](https://github.com/SaberSalv/saber/wiki/Install)

	$ gem install saber

Development
===========

Contributing
------------

* Submit any bugs/features/ideas to github issue tracker.
