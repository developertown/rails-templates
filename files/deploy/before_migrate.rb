Chef::Log.info("Running deploy/before_migrate.rb...")

rails_env = new_resource.environment["RAILS_ENV"]

Chef::Log.info("Precompiling assets for #{rails_env}...")

current_release = release_path

# execute "update deploy user npm ownership" do
#   cwd current_release
#   command "chown -R deploy:www-data ~/.npm"
# end
 
execute "rake assets:precompile" do
  user "deploy"
  group "www-data"
  cwd current_release
  command "bundle exec rake assets:precompile"
  environment "RAILS_ENV" => rails_env
end
