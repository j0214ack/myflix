Fabricator(:category) do
  name { sequence { |i| "category #{i}" } }
end
