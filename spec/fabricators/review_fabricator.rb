Fabricator(:review) do
  user
  video
  rating { Review::RATING_RANGE.sample }
  comment { Faker::Lorem.paragraph(2) }
end
