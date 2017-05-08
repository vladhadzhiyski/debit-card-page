# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

user1 = User.create(first_name: "Tom", last_name: "Hanks")
user2 = User.create(first_name: "Johnny", last_name: "Depp")

DebitCard.create!(
  card_number: "4242424242424242",
  expiration_month: 1,
  expiration_year: 2021,
  cvv: 111,
  user_id: user1.id
)

DebitCard.create!(
  card_number: "2222222222222222",
  expiration_month: 2,
  expiration_year: 2022,
  cvv: 222,
  user_id: user1.id
)

DebitCard.create!(
  card_number: "3333333333333333",
  expiration_month: 3,
  expiration_year: 2023,
  cvv: 333,
  user_id: user2.id
)

DebitCard.create!(
  card_number: "4444444444444444",
  expiration_month: 4,
  expiration_year: 2024,
  cvv: 444,
  user_id: user2.id
)
