namespace :packages do
  desc 'Index all packages'
  task index: :environment do
    IndexPackages.new.call
  end
end
