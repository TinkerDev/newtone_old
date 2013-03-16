require "bundler/setup"
load 'deploy'
# Uncomment if you are using Rails' asset pipeline
load 'deploy/assets'
load 'config/deploy' # remove this line to skip loading any of the default tasks

namespace :solr do
  desc "Выполняет rake sunspot:reindex"
  task :restart do
    begin
      run("cd #{deploy_to}/current && /usr/bin/env rake newtone:solr:stop RAILS_ENV=#{rails_env}")
    rescue Exception => error
      puts "***Unable to stop Solr with error: #{error}"
      puts "***Solr may have not been started. Continuing anyway.***"
    end
    run("cd #{deploy_to}/current && /usr/bin/env rake newtone:solr:start RAILS_ENV=#{rails_env}")
  end

  desc "Запускает фонове выполнение rake sunspot:reindex"
  task :background do
    #run "cd #{current_path} && exec nohup #{rake} RAILS_ENV=#{rails_env} sunspot:reindex > /tmp/sunspot_reindex.log < /dev/null 2>&1 & "
  end
end