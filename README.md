![DeveloperTown](http://www.developertown.com/wp-content/themes/dt2/images/header_devtown_logo.png)

### DeveloperTown Rails Application Templates

This is a set of starting points for Rails applications to help kickstart development of new applications.

------------------------------------------------------------------------------

#### 1. basic_template.rb
Highlights of this template include:

* Authentication/Authorization with Devise/Cancan
* HAML + Twitter Bootstrap (Sass version)
* Simple Form
* Deployment to OpsWorks
* Testing via rspec+factory_girl+guard+zeus, coverage with simplecov

To use it, run:

    rvm use 2.1                            # (if you need it)
    gem install rails --no-ri --no-rdoc    # (if you need it)
    rails new my_new_app -m https://raw.github.com/developertown/rails3-application-templates/master/basic_template.rb

##### Important post-build things to do:

1. Ensure you have defined default url options in your environments files. Here is an example of ```default_url_options``` appropriate for a development environment in config/environments/development.rb:

    ```config.action_mailer.default_url_options = { :host => 'localhost:3000' }```

2. Before deploying to CI, create a CI database and environment configuration.
3. Before deploying to CI, update config/deploy.rb and the associated capistrano environment configs with appropriate configuration.
4. Be sure to change the default ActiveAdmin username/password (u: admin@example.com, p: password)

##### How to create static pages
1. Create a file in the home folder with the same name as the url you want the page to use (i.e. organic.html.haml will be available at localhost:3000/organic)
2. That's it. Magic!


##### How to switch to a fluid layout
1. Delete application.html.haml or rename it to something like application_fixed.html.haml
2. Rename application_fluid.html.haml application.html.haml
3. Modify the default css in application.css to make it work for a fluid layout

##### How to add scaffolding
    rails g scaffold Post title:string description:text
    rake db:migrate
    rails g bootstrap:themed Posts
    
More info: https://github.com/seyhunak/twitter-bootstrap-rails