puts 'Load rails environment..'

require File.expand_path('../../config/application', __FILE__)
Bundler.require :daemons
require 'forever'

# Вместо этого подгружаем environment через rake
# чтобы другие rake-задачи его не подгружали повторно
#
# require File.expand_path('../../config/environment', __FILE__)
#
module ForeverbConfig
  def init_foreverb_config filename
    base = self
    base.instance_eval do
      ##
      # You can set these values:
      #
      # dir  "foo"     # Default: File.expand_path('../../', __FILE__)
      # Default: __FILE__
      #
      puts "File: #{file} #{filename}"

      if file=~/wwwnewtone/
        deploy_dir = '/home/wwwnewtone/newtone.name'
        puts "Foreverb deploy directory: #{deploy_dir}"
        dir "#{deploy_dir}/current/"
        file "#{deploy_dir}/current/script/#{filename}"
        log  "#{deploy_dir}/shared/log/#{filename}.log"
        pid "#{deploy_dir}/shared/pids/#{filename}.pid"
      else
        pid "tmp/pids/#{filename}.pid"
      end

      on_error do |e|
        puts "Boom raised: #{e.message}"
        Airbrake.notify(e)
      end

    end

  end
end
