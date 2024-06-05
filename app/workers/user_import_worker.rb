class UserImportWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    User.import_users
  end

end