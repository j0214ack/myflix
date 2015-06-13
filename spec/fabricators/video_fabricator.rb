Fabricator(:video) do
  title { Faker::Lorem.words(2).join(' ') }
  description { Faker::Lorem.paragraph(2) }
  small_cover_url do
    '/tmp/small/' + Dir.entries("#{Rails.public_path}/tmp/small/")[2..-1].sample
  end
  large_cover_url do
    '/tmp/large/' + Dir.entries("#{Rails.public_path}/tmp/large/")[2..-1].sample
  end
  category
end
