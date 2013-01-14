#
#              .+????.                 
#            .?????????:.              
#         .,??????????????.            
#       .???????????????????..         
#    ..?????????.. ..??????????.       
#  .?????????~.       ..?????????..    
# I????????..            .+????????.   
#  .????~. .,,,,.    ,,,,,...????+.    
#   .?..   .????:    ?????.   .=.      
#          .????:    ?????.            
#          .????:    ?????.            
#    =??????????????????????????:      
#    =??????????????????????????,      
#    =??????????????????????????,      
#    .......????:....+????.......      
#          .????:    ?????.            
#          .????:    ?????.            
#    ~?+++++?????++++??????++++?,      
#    =??????????????????????????,      
#    =??????????????????????????,      
#    .......????~....+????.......      
#          .????:    ?????.            
#          .????:    ?????.            
#           ????:    ?????.            
#          ......    ......
#
# =======================================================================
# Base DeveloperTown Rails Application Template
# =======================================================================
#
# The following template builds out a basic rails application with the
# following high-level capabilities:
#
# * Authentication/Authorization with Devise/Cancan
# * HAML + Twitter Bootstrap (Sass version)
# * SimpleForm/NestedForm
# * Deployment with capistrano + foreman + puma
# * Testing via rspec+factory_girl+guard, coverage with simplecov

run "rm public/index.html"

# Core app dependencies
gem 'mysql2'
gem 'haml'
gem 'haml-rails'
gem 'twitter-bootstrap-rails'
gem 'less-rails'
gem 'formtastic'
gem "formtastic-bootstrap"
gem 'nested_form', :git => 'git://github.com/ryanb/nested_form.git'
gem 'devise'
gem 'cancan'

# Administration
gem 'activeadmin'
gem "meta_search", '>= 1.1.0.pre'


# Deployment/runtime
gem 'capistrano', :require => false
gem 'capistrano-ext', :require => false
gem 'capistrano-helpers', :require => false
gem 'capistrano_colors', :require => false
gem 'rvm-capistrano', :require => false
gem 'libv8', '~> 3.11.8'
gem 'therubyracer', :require => false

gem 'foreman', :require => false
gem 'puma', :require => false

gem_group :development do
  gem "better_errors"
  gem "binding_of_caller"
end

gem_group :development, :test do
  gem 'yard', :require => false
  gem 'simplecov', :require => false
  gem 'simplecov-rcov', :require => false
  gem 'rails3-generators'
  gem 'guard', :require => false
  gem 'guard-rspec', :require => false
  gem 'guard-spork', :require => false
  gem 'growl', :require => false
  gem "pry"
  gem "pry-nav"
end

# Testing
gem_group :test do
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
end

run("bundle install")

# Set app configuration
app_config = <<-CFG
    config.generators do |g|
      g.test_framework :rspec, :views => false
      g.template_engine :haml
    end
CFG
insert_into_file 'config/application.rb', app_config, :after => "config.assets.version = '1.0'\n"

# Run all the necessary generators
generate 'bootstrap:install less'
generate 'bootstrap:layout application fixed'
generate 'bootstrap:layout application_fluid fluid'
generate 'formtastic:install'
generate 'nested_form:install'
generate 'devise:install'
generate 'devise:views', '-e', 'erb'
generate :model, 'user'
generate 'devise', 'user'
generate :controller, 'home', 'index'
generate 'rspec:install'
generate 'active_admin:install'
generate 'active_admin:resource', 'user'

run "bundle exec guard init"
run "bundle exec spork --bootstrap"
run "rm spec/spec_helper.rb"  #We're about to overwrite it...
get "https://raw.github.com/developertown/rails3-application-templates/master/files/spec/spec_helper_with_spork_and_simplecov.rb", "spec/spec_helper.rb"
run "rm Guardfile"  #We're about to overwrite it...
get "https://raw.github.com/developertown/rails3-application-templates/master/files/Guardfile", "Guardfile"
run "rm -rf test" #This is the unneeded test:unit test dir
run "mv app/assets/javascripts/active_admin.js vendor/assets/javascripts/"
run "mv app/assets/stylesheets/active_admin.css.scss vendor/assets/stylesheets/"

# Convert devise views to haml

def gem_available?(name)
  Gem::Specification.find_by_name(name)
rescue Gem::LoadError
  false
rescue
  Gem.available?(name)
end

run("gem install hpricot --no-ri --no-rdoc") unless gem_available?('hpricot')
run("gem install ruby_parser --no-ri --no-rdoc") unless gem_available?('ruby_parser')
run("for i in `find app/views/devise -name '*.erb'` ; do html2haml -e $i ${i%erb}haml ; rm $i ; done")

# Setup bootstrap
insert_into_file 'config/initializers/formtastic.rb', "Formtastic::Helpers::FormHelper.builder = FormtasticBootstrap::FormBuilder\n", :after => "# encoding: utf-8\n"
insert_into_file 'app/assets/javascripts/application.js', "//= require twitter/bootstrap\n", :after => "jquery_ujs\n"
insert_into_file 'app/assets/stylesheets/application.css', "*= require bootstrap_and_overrides\n", :after => "*= require_tree .\n"
# base_css = <<-CSS

# body {
#   /* For navbar */
#   padding-top: 60px;

#   /* For footer */
#   padding-bottom: 30px;
# }

# #footer {
#   background:#ffffff;
#   margin-top:5px;
#   text-align:center;
#   border-top:1px solid #dedede;
#   position: fixed;
#   width: 100%;
#   bottom: 0;
# }

# #footer .p {
#   font-size:12px;
#   margin-top:5px;
# }
# CSS

insert_into_file 'config/initializers/active_admin.rb', 'config.skip_before_filter :authenticate_user!', :after => "# == Controller Filters\n"
# insert_into_file 'app/assets/stylesheets/application.css', base_css, :after => "*/\n"
run "mv app/assets/stylesheets/application.css app/assets/stylesheets/application.css.scss"

run "rm app/views/layouts/application.html.erb"
get "https://raw.github.com/developertown/rails3-application-templates/master/files/app/views/layouts/bootstrap_haml_layout.html.haml", "app/views/layouts/application.html.haml"

route "root :to => 'home#index'"
route "match ':action' => 'home#:action'"


#Drop in capistrano configuration
get "https://raw.github.com/developertown/rails3-application-templates/master/files/Capfile", "Capfile"
get "https://raw.github.com/developertown/rails3-application-templates/master/files/config/deploy.rb", "config/deploy.rb"
get "https://raw.github.com/developertown/rails3-application-templates/master/files/config/deploy/cat.rb", "config/deploy/cat.rb"
get "https://raw.github.com/developertown/rails3-application-templates/master/files/config/deploy/ci.rb", "config/deploy/ci.rb"

#Foreman configuration
get "https://raw.github.com/developertown/rails3-application-templates/master/files/Procfile", "Procfile"
get "https://raw.github.com/developertown/rails3-application-templates/master/files/lib/foreman/templates/upstart/master.conf.erb", "lib/foreman/templates/upstart/master.conf.erb"
get "https://raw.github.com/developertown/rails3-application-templates/master/files/lib/foreman/templates/upstart/process.conf.erb", "lib/foreman/templates/upstart/process.conf.erb"
get "https://raw.github.com/developertown/rails3-application-templates/master/files/lib/foreman/templates/upstart/process_master.conf.erb", "lib/foreman/templates/upstart/process_master.conf.erb"


rake("db:migrate")

#RVM
create_file '.rvmrc' do 
    <<-RVM
rvm use 1.9.3
RVM
end


git :init
git :add => "."
git :commit => "-a -m 'Initial commit'"


puts ""
puts ""
puts ""
puts "All Set!"
puts ""
puts "Some setup you must do manually:"
puts ""
puts "   1. Ensure you have defined default url options in your environments files. Here"
puts "      is an example of default_url_options appropriate for a development environment"
puts "      in config/environments/development.rb:"
puts ""
puts "        config.action_mailer.default_url_options = { :host => 'localhost:3000' }"
puts ""
puts "   2. Before deploying to CI, create a CI database and environment configuration."
puts ""
puts "   3. Before deploying to CI, update config/deploy.rb and the associated capistrano environment"
puts "      configs with appropriate configuration."
puts ""
puts ""
