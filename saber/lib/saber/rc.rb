api_url = "http://saberapi.heroku.com"
scgi_server = "http://localhost/RPC2"
browser = [:firefox]
book_exts = %w[.epub .mobi .pdf .txt .html .djvu .chm .cbr .cbz .azw3]
book_formats = %w[epub mobi pdf txt html djvu chm cbr cbz azw3]

p:
  root = Pa.expand("../../..", __FILE__)
  home = Pa("~/.saber")
  homerc = Pa("~/.saberrc")
  database = Pa("~/.saber/database")
  template = Pa("~/.saber/templates")

aria2:
  rpc = "http://localhost:6800/rpc"

port = 3014
token = "641a16655dad688ab681c0279a4369b5"
drb_uri = "druby://localhost:3015"

server:
  xmpp:
    host = nil
    port = nil

client:
  xmpp:
    host = nil
    port = nil
