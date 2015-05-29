# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.find_or_create!(name: "TV Comedies")
Category.find_or_create!(name: "TV Drama")
Category.find_or_create!(name: "Reality TV")

Video.create!([
  {
    title: "Family Guy",
    description: %Q{Sick, twisted and politically incorrect, the animated
      series features the adventures of the Griffin family. Endearingly
      ignorant Peter and his stay-at-home wife Lois reside in Quahog, R.I.,
      and have three kids. Meg, the eldest child, is a social outcast, and
      teenage Chris is awkward and clueless when it comes to the opposite
      sex. The youngest, Stewie, is a genius baby bent on killing his mother
      and destroying the world. The talking dog, Brian, keeps Stewie in check
      while sipping martinis and sorting through his own life issues.},
    small_cover_url: "/tmp/family_guy.jpg",
    large_cover_url: "/tmp/tom_and_jerry_large.jpg",
    category: Category.offset(rand(Category.count)).first
  },
  {
    title: "Futurama",
    description: %Q{Accidentally frozen, pizza-deliverer Fry wakes up 1,000
       years in the future. He is taken in by his sole descendant, an elderly
       and addled scientist who owns a small cargo delivery service. Among
       the other crew members are Capt. Leela, accountant Hermes, intern Amy,
       obnoxious robot Bender and lobsterlike moocher "Dr." Zoidberg.},
    small_cover_url: "/tmp/futurama.jpg",
    large_cover_url: "/tmp/futurama_large.jpg",
    category: Category.offset(rand(Category.count)).first
  },
  {
    title: "Monk",
    description: %Q{After the unsolved murder of his wife, Adrian Monk develops
       obsessive-compulsive disorder, which includes his terror of germs and
       contamination. His condition costs him his job as a prominent homicide
       detective in the San Francisco Police Department, but he continues to
       solve crimes with the help of his assistant and his former boss.},
    small_cover_url: "/tmp/monk.jpg",
    large_cover_url: "/tmp/monk_large.jpg",
    category: Category.offset(rand(Category.count)).first
  },
  {
    title: "South Park",
    description: %Q{The animated series is not for children. In fact, its goal
      seems to be to offend as many as possible as it presents the adventures
      of Stan, Kyle, Kenny and Cartman. The show has taken on Saddam Hussein,
      Osama bin Laden, politicians of every stripe and self-important
      celebrities. Oh, and Kenny is killed in many episodes.},
    small_cover_url: "/tmp/south_park.jpg",
    large_cover_url: "/tmp/star_wars_large.jpg",
    category: Category.offset(rand(Category.count)).first
  }])
