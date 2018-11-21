# rubocop:disable Metrics/BlockLength

require 'userlist/rails/importer'

namespace :userlist do
  namespace :import do
    desc 'Import users into Userlist.io'
    task users: :environment do
      if user_model = Rails.application.config.userlist.user_model
        importer = Userlist::Rails::Importer.new
        importer.import(user_model) do |user|
          push.user(user.send(:userlist_payload))
        end
      else
        puts 'No user model defined. Skipping import.'
      end
    end

    desc 'Import companies into Userlist.io'
    task companies: :environment do
      if company_model = Rails.application.config.userlist.company_model
        importer = Userlist::Rails::Importer.new
        importer.import(company_model) do |company|
          push.company(company.send(:userlist_payload))
        end
      else
        puts 'No company model defined. Skipping import.'
      end
    end
  end

  desc 'Import users and companies into Userlist.io'
  task import: ['userlist:import:users', 'userlist:import:companies']
end

# rubocop:enable Metrics/BlockLength
