![DeveloperTown](http://www.developertown.com/wp-content/themes/dt2/images/header_devtown_logo.png)

### DeveloperTown Rails Application Templates

This is a set of starting points for Rails applications to help kickstart development of new applications.

------------------------------------------------------------------------------

#### [id]1. basic_template.rb
Highlights of this template include:

* Authentication/Authorization with Devise/Cancan
* HAML + Twitter Bootstrap (Sass version)
* SimpleForm/NestedForm
* Deployment with capistrano + foreman + thin
* Testing via rspec+factory_girl+guard, coverage with simplecov

To use it, run:

    rvm use 1.9.3                          # (if you need it)
    gem install rails --no-ri --no-rdoc    # (if you need it)
    rails new my_new_app -m https://raw.github.com/developertown/rails3-application-templates/master/basic_template.rb