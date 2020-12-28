TODO
----

It's a part of [saber](https://github.com/SaberSalv/saber) project.

**Limits**

- imgur limit 50 uploads per hour per ip.

Usage
------

	$ curl -L saberapi.heroku.com/books/9780590353403

Install & Run in local
-----------------------

Prepare

- Goodreads api key: http://www.goodreads.com/api/keys
- Google Books api key: https://code.google.com/apis/console/
- Amazon api key: https://affiliate-program.amazon.com/

Run

	$ bundle install
	$ cp _env-sample .env and edit it
	$ bundle exec foreman start
	$ curl -L localhost:5001/books/9780590353403

Deploy to heroku
----------------

	$ heroku create PROJECT
	$ heroku plugins:install git://github.com/ddollar/heroku-config.git             
	$ heroku config:pull --overwrite --interactive                                  
	$ heroku config:push
	$ git push origin heroku
