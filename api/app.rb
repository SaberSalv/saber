#!/usr/bin/env ruby

$:.push "#{File.dirname(__FILE__)}/lib"
require "bundler/setup"
require "sinatra"
require "saber_api"
#Bundler.require :default, settings.environment

get "/books/:isbn" do |isbn|
  content_type :json

  SaberAPI.book(isbn, params).to_json
end

get "/" do
  "Hello World"
end
