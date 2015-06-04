Fabricator(:video) do
  title { Fake::Lorem.word(2).join(" ") }
  description { Fake::Lorem.paragraph(2) }
end
