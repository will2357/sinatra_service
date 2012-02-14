web:	bundle exec rackup config.ru -p $PORT
worker: bundle exec rake jobs:work
clock:  bundle exec rake resque:scheduler
