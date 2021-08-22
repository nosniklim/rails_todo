# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Note: run 'rails db:reset' if you want to reset development environment!
# Create User accounts
User.create(name: 'Guest', email: 'guest@example.com', password: 'guest#1')
User.create(name: 'Other guest', email: 'other_guest@example.com', password: 'guest#2')

# Create Lists
List.create(title: 'Backlog', user_id: 1, position: 1)
List.create(title: 'To Do', user_id: 1, position: 2)
List.create(title: 'Doing', user_id: 1, position: 3)
List.create(title: 'Review', user_id: 1, position: 4)
List.create(title: 'Testing', user_id: 1, position: 5)
List.create(title: 'Done', user_id: 1, position: 6)

# Create Cards
Card.create(title: 'Feature #1', memo: 'things to do', list_id: 3, position: 1)
Card.create(title: 'Feature #2', memo: 'things to do', list_id: 1, position: 1)
Card.create(title: 'Feature #3', memo: 'things to do', list_id: 1, position: 2)
Card.create(title: 'Feature #4', memo: 'things to do', list_id: 1, position: 3)
Card.create(title: 'Feature #5', memo: 'things to do', list_id: 1, position: 4)

Card.create(title: 'Security audit', memo: 'things to do', list_id: 2, position: 1)
Card.create(title: 'API improvements', memo: 'things to do', list_id: 2, position: 2)
Card.create(title: 'Bug fix', memo: 'things to do', list_id: 4, position: 1)
Card.create(title: 'Major release(1.0.0)', memo: 'things to do', list_id: 6, position: 1)

7.times do |i|
  l = i + 1
  List.create(title: "#{l}"*3, user_id: 2, position: l)
  5.times do |j|
    c = j + 1
    Card.create(title: "Task #{l}#{c}", memo: "do #{l}-#{c}", list_id: l + 6, position: c)
  end
end