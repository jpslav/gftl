set :user, 'jpslav'  # Your dreamhost account's username
set :domain, 'jpslav.com'  # Dreamhost servername where your account is located 
set :ssh_options, { :forward_agent => true }
set :application, 'gftl.jpslav.com'  # Your app's location (domain or sub-domain name as setup in panel)
set :applicationdir, "/srv/www/#{application}"  # The standard Dreamhost setup

# version control config

set :repository_filename, "/srv/git/gftl-2.git"
set :scm, :git
set :repository, "file://#{repository_filename}"
set :local_repository, "jpslav@jpslav.com:#{repository_filename}"
set :branch, "master"

# roles (servers)
role :web, domain
role :app, domain
role :db,  domain, :primary => true

# deploy config
set :deploy_to, applicationdir
set :deploy_via, :remote_cache

# additional settings
default_run_options[:pty] = true  # Forgo errors when deploying from windows
#ssh_options[:keys] = %w(/Path/To/id_rsa)            # If you are using ssh_keys
#set :chmod775, "app config db lib public vendor script script/* public/disp*"
set :use_sudo, false

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
