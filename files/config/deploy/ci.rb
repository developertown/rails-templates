set :branch, 'master'
set :rails_env, 'ci'

# CONFIGURE THIS
role :web, "fubar.developertown.com"                          # Your HTTP server, Apache/etc
# CONFIGURE THIS
role :app, "fubar.developertown.com"                          # This may be the same as your `Web` server
# CONFIGURE THIS
role :db,  "fubar.developertown.com", :primary => true        # This is where Rails migrations will run