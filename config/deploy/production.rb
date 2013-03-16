#server '23.21.177.80', :app, :web, :db, :primary => true
server 'icfdev.ru', :app, :web, :db, :primary => true
set :branch, "master" unless exists?(:branch)
set :rails_env, "production"
#set :application, "newtone.name"
#set :user,      'wwwswap'
#require 'airbrake/capistrano'
after 'deploy:restart', 'solr:background'

#Конфиг деплоя на production
#server '144.76.6.142', :app, :web, :db, :primary => true
#set :branch, "master" unless exists?(:branch)
#set :rails_env, "production"
#set :user,      'gridology'
#
#require 'airbrake/capistrano'
#
#after 'deploy:restart', 'solr:background'