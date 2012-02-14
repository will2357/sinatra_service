require 'rubygems'
require 'bundler'

Bundler.require

require './sinatra_service'
require 'resque/server'

run Rack::URLMap.new \
  "/"	    => SinatraService.new,
  "/resque" => Resque::Server.new
