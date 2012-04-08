# RVM bootstrap
$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require 'rvm/capistrano'                               # Load RVM's capistrano plugin.
set :rvm_ruby_string, '1.9.3'
set :rvm_type, :system
set :rvm_bin_path, '/usr/local/rvm/bin'
set :deploy_via, :remote_cache

# bundler bootstrap
require 'bundler/capistrano'

# CONFIGURE THIS
set :application, 'App_Name'

# CONFIGURE THIS
set :repository,  'ssh://git@github.com/developertown/repo.git'
set :scm, :git

# CONFIGURE THIS
set :deploy_to, '/srv/www/app_name'
# CONFIGURE THIS
set :user, 'app_user'
set :use_sudo, false
# CONFIGURE THIS
set :scm_username, 'app_user'

# support multiple deployment targets
set :default_stage, 'ci'
set :stages, %w(ci cat)
require 'capistrano/ext/multistage'

# Rails 3.1+ needs this...
set :normalize_asset_timestamps, false

before 'deploy:code', :set_tag
after 'deploy:update_code', 'deploy:migrate'
after 'deploy:update_code', 'deploy:cleanup'
after "deploy:restart", 'monit:reload'


before 'monit:start', 'monit:touch'
before 'monit:reload', 'monit:touch', 'monit:start'

namespace :monit do
  desc "Stop the running instance of monit running as trooptrack"
  task :stop, :except => {:no_release => true} do
    run "if ps -p $(cat #{File.join(current_path,'tmp','pids','monit.pid')}) > /dev/null; then kill -9 $(cat #{File.join(current_path,'tmp','pids','monit.pid')}); fi"
  end

  desc "Start the monit daemon running as trooptrack"
  task :start, :except => {:no_release => true} do
    run "chmod 700 #{File.join(current_path,'config',"monitrc-#{rails_env}")}; /usr/sbin/monit -c #{File.join(current_path,'config',"monitrc-#{rails_env}")}"
  end

  desc "Reload the configs"
  task :reload, :except => {:no_release => true} do
    run "chmod 700 #{File.join(current_path,'config',"monitrc-#{rails_env}")}; /usr/sbin/monit -c #{File.join(current_path,'config',"monitrc-#{rails_env}")} reload"
  end

  desc "Touch monit config, make sure the permissions are correct"
  task :touch, :except => {:no_release => true} do
    run "chmod 700 #{File.join(current_path,'config',"monitrc-#{rails_env}")}"
  end
end
