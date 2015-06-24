rvm use 2.1.0 --install
bundle install

export RAILS_ENV=test

bundle exec rake db:drop db:create db:migrate db:seed
