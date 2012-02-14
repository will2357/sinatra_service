require 'rubygems'
require 'sinatra'
require 'resque'
require 'resque_scheduler'
require 'httparty'
require 'typhoeus'

# NB: Sinatra::Base.environment defaults to ENV['RACK_ENV']
set :environment, :production if ENV["REDISTOGO_URL"] 

uri = URI.parse(ENV["REDISTOGO_URL"] || 'redis://localhost:6379')
Resque.redis = Redis.new(host: uri.host, port: uri.port, password: uri.password)
Resque.schedule = YAML.load_file('./resque_schedule.yml')

class SampleJob
  @queue = :sample_queue

  def self.perform(thing)
    puts "Do #{thing}"
  end
end

class TwitterExample
  include HTTParty
  base_uri 'search.twitter.com'
  format :json
end

class SinatraService < Sinatra::Base
  get '/' do
    "<a href='/resque'>Resque Overview</a><br/><a href='/sample_job/aargh'>Enqueue 'aargh'</a><br/><a href='/twitter/adaptly'>Search Twitter for 'Adaptly'</a><br/><a href='/fast_twitter/adaptly'>Fast Search Twitter for 'Adaptly'</a>"
  end

  get '/sample_job/:thing' do
    Resque.enqueue(SampleJob, params['thing'])
    "Put #{params['thing']} enqueue. Wait 3 seconds."
    redirect "/resque/queues/sample_queue"
  end

  get '/twitter/:query' do
    TwitterExample.get('/search.json',:query=>{q: params['query']})['results'].to_json
  end

  get '/fast_twitter/:query' do
    Typhoeus::Request.get('http://search.twitter.com/search.json', params: {q: params['query']}).body    
  end
end
