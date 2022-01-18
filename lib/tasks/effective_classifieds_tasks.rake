namespace :effective_classifieds do

  # bundle exec rake effective_classifieds:seed
  task seed: :environment do
    load "#{__dir__}/../../db/seeds.rb"
  end

end
