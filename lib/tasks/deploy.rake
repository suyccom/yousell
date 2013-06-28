# encoding: utf-8
 
#For this script to work, please check that rvm is loaded in non interactive shells
#To do that, edit .bashrc and move the RVM line to the top of the file
 
require 'whiskey_disk/helpers'
 
namespace :deploy do
  task :bundle_gems do
    system("bundle")
  end
 
  task :db_migrate_if_necessary do
    puts "Checking whether to run migrations"
    if changed?('db/migrate')
      puts "Yes, we are running migrations"
      #Rake::Task['db:migrate']
      system("rake db:migrate")
    end
  end
 
  task :assets_precompile_if_necessary do
    puts "Checking whether to compile assets"
    if changed?('app/assets')
      puts "Yes, we are compiling assets"
      system("rake assets:precompile")
    end
  end
 
  task :restart_passenger do
    puts "restarting Passenger web server"
    system("touch tmp/restart.txt")
    system("wget http://demo.asedoc.es -O /dev/null")
  end
 
  task :post_deploy => [ :bundle_gems, 
                         :db_migrate_if_necessary, 
                         :assets_precompile_if_necessary,
                         :restart_passenger ]
end
 
 
 
task :deploy do
  system("rake deploy:now to=production")
  system("notify-send -u critical -i /usr/share/icons/gnome/256x256/mimetypes/libreoffice-oasis-web-template.png 'Deploy en producción completado'")
end
