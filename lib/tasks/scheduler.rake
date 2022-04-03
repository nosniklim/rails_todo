namespace :heroku do
  desc 'delete all the heroku data in DATABASE'
  task reset: :environment do
    Card.delete_all
    List.delete_all
    User.delete_all
    load(Rails.root.join('db/seeds.rb'))
  end
end
