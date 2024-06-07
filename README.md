# README

Hi and Welcome!

Steps to use this application

1. bundle install

2. setup postgres in your system and define login credentials in database.yml and run these commands.
    rails db:create
    rails db:migrate
   
3. check these workers, Start sidekiq server and trigger them to test in rails console

    bundle exec sidekiq
    UserImportWorker.perform_async
    DailyReportWorker.perform_async

4. Start rails server to view the UI

   rails s

   # Users list
   http://localhost:3000/

   # Report
   http://localhost:3000/daily_records

