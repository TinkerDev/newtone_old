set :stages, %w(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

set :application, "newtone.name"

set :scm, :git
set :repository,  "git@github.com:BrandyMint/Newtone.git"
set :deploy_via, :remote_cache
set :scm_verbose, true
ssh_options[:forward_agent] = true

set :user,      'wwwnewtone'
set :deploy_to,  defer { "/home/#{user}/#{application}" }
set :use_sudo,   false

set :keep_releases, 5
set :shared_children, fetch(:shared_children) + %w(public/uploads)

set :rvm_ruby_string, "1.9.3-p392"
set :rvm_type, :user

before 'deploy:setup', 'rvm:install_rvm'
before 'deploy:setup', 'rvm:install_ruby'
before 'deploy:restart', 'deploy:migrate'
after 'deploy:restart', "deploy:cleanup"

#RVM, Bundler
require "rvm/capistrano"
require "bundler/capistrano"
require "recipes0/assets"
require "recipes0/database_yml"
require "recipes0/db/pg"
require "recipes0/init_d/unicorn"
require "recipes0/nginx"

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'deploy')
require "resque"

namespace :newtone do
  desc "Download uploads from remote server"
  task :pull_uploads, roles => :web, :except => { :no_release => true } do
    server = find_servers_for_task(current_task).first

    ssh_port = server.port || ssh_options[:port] || 22
    ssh_user = fetch(:user)
    ssh_server = ssh_user ? "#{ssh_user}@#{server.host}" : server.host

    run_locally("rsync -az --stats --delete --rsh='ssh -p #{ssh_port}' #{ssh_server}:#{current_path}/public/uploads/ public/uploads/")
  end

  desc "Copy dataabse and uploads from remote server"
  task :pull do
    newtone.pull_uploads
    db.pull
  end

  namespace :log do

    desc "show log file list"
    task :list, :role => :app do
      run "ls -la #{shared_path}/log/"
    end

    desc "tail log files"
    task :tail, :roles => :app do
      run "tail -f #{shared_path}/log/#{logfile}" do |channel, stream, data|
        puts "#{channel[:host]}: #{data}"
        break if stream == :err
      end
    end
  end
end
