# https://gist.github.com/2161449
# /applications/note on squire
# /applications/note/shared/config for config files

require "bundler/capistrano"
require 'rvm/capistrano'

set :rvm_ruby_string, '1.9.3@note-gems'

set :application, "note"
set :repository,  "git@github.com:akdarrah/note.git"
set :deploy_to, "/applications/#{application}"

set :scm, :git
ssh_options[:forward_agent] = true
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

server "squire", :app, :web, :db, :primary => true

# https://groups.google.com/forum/?fromgroups#!topic/capistrano/554ehbCE45o
default_run_options[:pty] = true

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

before 'deploy:assets:precompile' do
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  run "ln -nfs #{shared_path}/config/last_fm.yml #{release_path}/config/last_fm.yml"
  run "ln -nfs #{shared_path}/config/youtube.yml #{release_path}/config/youtube.yml"
end

# Forces a migrate after every deploy
after 'deploy:update_code', 'deploy:migrate'

# only keep the 5 latest releases
set :keep_releases, 5
after "deploy:restart", "deploy:cleanup"
