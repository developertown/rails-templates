Chef::Log.info("Running deploy/before_migrate.rb...")

rails_env = new_resource.environment["RAILS_ENV"]

Chef::Log.info("Precompiling assets for #{rails_env}...")

current_release = release_path
 
execute "rake assets:precompile" do
  user "deploy"
  group "www-data"
  cwd current_release
  command "bundle exec rake assets:precompile"
  environment new_resource.environment
end
