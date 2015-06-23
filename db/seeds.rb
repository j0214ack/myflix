# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

categories = Fabricate.times(3, :category)

videos = []
18.times do
  videos << Fabricate(:video, category: categories.sample)
end

videos.each do |v|
  Fabricate.times(10, :review, video: v)
end

User.create(email: 'a@example.com',
            password: 'password',
            password_confirmation: 'password',
            full_name: 'Jack Chen')
