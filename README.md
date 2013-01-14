![DeveloperTown](http://www.developertown.com/wp-content/themes/dt2/images/header_devtown_logo.png)

### DeveloperTown Rails Application Templates

This is a set of starting points for Rails applications to help kickstart development of new applications.

------------------------------------------------------------------------------

#### 1. basic_template.rb
Highlights of this template include:

* Authentication/Authorization with Devise/Cancan
* HAML + Twitter Bootstrap (Less version)
* Formtastic/NestedForm
* Deployment with capistrano + foreman + puma
* Testing via rspec+factory_girl+guard, coverage with simplecov
* Management with ActiveAdmin

To use it, run:

    rvm use 1.9.3                          # (if you need it)
    gem install rails --no-ri --no-rdoc    # (if you need it)
    rails new my_new_app -m https://raw.github.com/davidray/rails3-application-templates/master/basic_template.rb

##### Important post-build things to do:

1. Ensure you have defined default url options in your environments files. Here is an example of ```default_url_options``` appropriate for a development environment in config/environments/development.rb:

    ```config.action_mailer.default_url_options = { :host => 'localhost:3000' }```

2. Before deploying to CI, create a CI database and environment configuration.
3. Before deploying to CI, update config/deploy.rb and the associated capistrano environment configs with appropriate configuration.
4. Be sure to change the default ActiveAdmin username/password (u: admin@example.com, p: password)

##### How to create static pages
1. Create a file in the home folder with the same name as the url you want the page to use (i.e. organic.html.haml will be available at localhost:3000/organic)
2. That's it. Magic!
