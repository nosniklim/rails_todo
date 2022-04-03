# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# NOTE: run 'rails db:reset' if you want to reset development environment!
# Create User accounts
User.create(id: 1, name: 'Guest', email: 'guest@example.com', password: 'guest#1')
User.create(id: 2, name: 'Other guest', email: 'other_guest@example.com', password: 'guest#2')

# Create Lists
List.create(id: 1, title: 'Backlog', user_id: 1, position: 1)
List.create(id: 2, title: 'To Do', user_id: 1, position: 2)
List.create(id: 3, title: 'Doing', user_id: 1, position: 3)
List.create(id: 4, title: 'Review', user_id: 1, position: 4)
List.create(id: 5, title: 'Testing', user_id: 1, position: 5)
List.create(id: 6, title: 'Done', user_id: 1, position: 6)

# Create Cards
Card.create(id: 1, title: 'Feature #1', memo: Faker::Lorem.sentence, list_id: 1, position: 1)
Card.create(id: 2, title: 'Feature #2', memo: Faker::Lorem.sentence, list_id: 1, position: 2)
Card.create(id: 3, title: 'Feature #3', memo: Faker::Lorem.sentence, list_id: 1, position: 3)
Card.create(id: 4, title: 'Feature #4', memo: Faker::Lorem.sentence, list_id: 1, position: 4)
Card.create(id: 5, title: 'Feature #5', memo: Faker::Lorem.sentence, list_id: 1, position: 5)

Card.create(id: 6, title: 'Feature #6', memo: Faker::Lorem.sentence, list_id: 2, position: 1)
Card.create(id: 7, title: 'Feature #7', memo: Faker::Lorem.sentence, list_id: 2, position: 2)
Card.create(id: 8, title: 'Feature #8', memo: Faker::Lorem.sentence, list_id: 2, position: 3)
Card.create(id: 9, title: 'Feature #9', memo: Faker::Lorem.sentence, list_id: 2, position: 4)
Card.create(id: 10, title: 'Feature #10', memo: Faker::Lorem.sentence, list_id: 2, position: 5)

Card.create(id: 11, title: 'Feature #11', memo: Faker::Lorem.sentence, list_id: 3, position: 1)
Card.create(id: 12, title: 'Feature #12', memo: Faker::Lorem.sentence, list_id: 3, position: 2)

7.times do |i|
  l = i + 1
  List.create(id: List.count + 1, title: l.to_s * 3, user_id: 2, position: l)
  5.times do |j|
    c = j + 1
    Card.create(id: Card.count + 1, title: "Task #{l}#{c}", memo: "do #{l}-#{c}", list_id: l + 6, position: c)
  end
end
