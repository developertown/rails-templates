# RVM bootstrap
$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require 'rvm/capistrano'                               # Load RVM's capistrano plugin.
set :rvm_ruby_string, '1.9.3'
set :rvm_type, :system
set :rvm_bin_path, '/usr/local/rvm/bin'
set :deploy_via, :remote_cache
default_run_options[:pty] = true

# bundler bootstrap
require 'bundler/capistrano'

# CONFIGURE THIS - VERY IMPORTANT THAT THERE ARE NO SPACES
set :application, 'App_Name'

# CONFIGURE THIS
set :repository,  'ssh://git@github.com/developertown/repo.git'
set :scm, :git

# CONFIGURE THIS
set :deploy_to, '/srv/www/appname'
# CONFIGURE THIS
set :user, 'appname'
set :use_sudo, false
# CONFIGURE THIS
set :scm_username, 'appname'

# support multiple deployment targets
set :default_stage, 'ci'
set :stages, %w(ci cat)
require 'capistrano/ext/multistage'

# Rails 3.1+ needs this...
set :normalize_asset_timestamps, false

# before 'deploy:code', :set_tag
after 'deploy:update_code', 'deploy:migrate'
after 'deploy:update_code', 'deploy:cleanup'

after 'deploy:update', 'dt:setenv'
after 'deploy:update', 'foreman:export'
after 'deploy:update', 'foreman:restart'

namespace :dt do
    desc "Sets the environment file for the app"
    task :setenv, :roles => :app, :except => {:no_release => true} do
      run "echo 'RAILS_ENV=#{rails_env}' > #{release_path}/.env"
      run "echo 'concurrency: web=1' > #{release_path}/.foreman"
      run "echo 'port: 15000' >> #{release_path}/.foreman"
    end
end

namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export, :roles => :app do
    run "cd #{release_path} && bundle exec foreman export upstart $HOME/.init -a #{application} -l #{shared_path}/log -t #{release_path}/lib/foreman/templates/upstart"
  end
  desc "Start the application services"
  task :start, :roles => :app do
    sudo "start #{application}"
  end

  desc "Stop the application services"
  task :stop, :roles => :app do
    sudo "stop #{application}"
  end

  desc "Restart the application services"
  task :restart, :roles => :app do
    run "start #{application} || restart #{application}"
  end
end
