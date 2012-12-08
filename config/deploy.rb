require "bundler/capistrano"
require 'fileutils'

set :application, "refectory"
set :repository,  "ssh://git.atevans.com/git/refectory.git"

set :scm, :git 
# You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :user,    'deploy'
set :group,   user
set :deploy_to, "/var/www/#{application}"

role :web, "linode.atevans.com"                          # Your HTTP server, Apache/etc
role :app, "linode.atevans.com"                          # This may be the same as your `Web` server
role :db,  "linode.atevans.com", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# This is needed to correctly handle sudo password prompt
default_run_options[:pty] = true

set :unicorn_env, 'production'
require 'capistrano-unicorn'

desc "Establishes sudo"
task :sudo_ls do
  sudo "ls"
end

namespace :deploy do
  task :symlink do
    run "ln -s #{deploy_to}/shared/tmp  #{release_path}/tmp"
    run "ln -s #{deploy_to}/public/assets/system  #{release_path}/shared/system"
  end
  
  task :upload_assets do
    `bundle exec rake assets:precompile`
    `tar -czf assets.tar.gz public/assets`
    top.upload(File.join(Dir.pwd, "assets.tar.gz"), "#{release_path}/assets.tar.gz")
    run "cd #{release_path} && tar -xzf assets.tar.gz"
    `rm -rf public/assets`
    `rm -rf assets.tar.gz`
  end
  
  task :start do
    unicorn.start
  end
  
  task :stop do 
    unicorn.stop
  end
  
  task :restart, :roles => :app, :except => { :no_release => true } do
    unicorn.stop
    sleep(2)
    unicorn.start
  end
end

namespace :unicorn do
  task :restart do
    unicorn.stop
    sleep(2)
    unicorn.start
  end
end

before 'deploy:update', 'sudo_ls'
before 'deploy:finalize_update', 'deploy:upload_assets'
before 'deploy:finalize_update', 'deploy:symlink'
# before 'deploy:finalize_update', 'deploy_assets'

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
