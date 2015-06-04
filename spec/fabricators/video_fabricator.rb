Fabricator(:video) do
  title { Faker::Lorem.word(2).join(" ") }
  description { Faker::Lorem.paragraph(2) }
end
