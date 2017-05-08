require 'rails_helper'

RSpec.describe DebitCard, type: :model do
  let(:user) { User.create(first_name: "First", last_name: "Last") }

  describe "success" do
    it "creates a new debit card" do
      expect do
        DebitCard.create!(
          card_number: "4444444444444441",
          expiration_month: 5,
          expiration_year: 2020,
          cvv: 123,
          user_id: user.id
        )
      end.to change{DebitCard.count}.by(1)

      card = DebitCard.last
      expect(card.last_four).to eq("4441")
      expect(card.expiration_month).to eq(5)
      expect(card.expiration_year).to eq(2020)
      expect(card.cvv).to eq(123)
      expect(card.user_id).to eq(user.id)
    end
  end

  describe "failures" do
    context "basic model validations" do
      it "does not create a debit card if card number is missing" do
        expect do
          DebitCard.create!(
            expiration_month: random_month,
            expiration_year: random_year,
            cvv: 123,
            user_id: user.id
          )
        end.to raise_error(ActiveRecord::RecordInvalid, /Card number can't be blank/)
      end

      it "does not create a debit card if expiration_month is missing" do
        expect do
          DebitCard.create!(
            card_number: random_card_number,
            expiration_year: random_year,
            cvv: 123,
            user_id: user.id
          )
        end.to raise_error(ActiveRecord::RecordInvalid, /Expiration month can't be blank/)
      end

      it "does not create a debit card if expiration_year is missing" do
        expect do
          DebitCard.create!(
            card_number: random_card_number,
            expiration_month: random_month,
            cvv: 123,
            user_id: user.id
          )
        end.to raise_error(ActiveRecord::RecordInvalid, /Expiration year can't be blank/)
      end

      it "does not create a debit card if cvv is missing" do
        expect do
          DebitCard.create!(
            card_number: random_card_number,
            expiration_month: random_month,
            expiration_year: random_year,
            user_id: user.id
          )
        end.to raise_error(ActiveRecord::RecordInvalid, /Cvv can't be blank/)
      end

      it "does not create a debit card if user is missing" do
        expect do
          DebitCard.create!(
            card_number: random_card_number,
            expiration_month: random_month,
            expiration_year: random_year,
            cvv: 123
          )
        end.to raise_error(ActiveRecord::RecordInvalid, /User can't be blank/)
      end
    end

    context "for restrictions" do
      it "does not create a debit card if expiration month is out of range" do
        expect do
          DebitCard.create!(
            card_number: random_card_number,
            expiration_month: 13,
            expiration_year: random_year,
            cvv: 123,
            user_id: user.id
          )
        end.to raise_error(ActiveRecord::RecordInvalid, /Expiration month must be between 1 and 12/)
      end
    end

    context "for a new debit card whose number is the same as an existing card" do
      it "fails to create the card if there is a card with the same number and expiration date in our DB" do
        card = DebitCard.create!(
          card_number: random_card_number,
          expiration_month: random_month,
          expiration_year: random_year,
          cvv: 123,
          user_id: user.id
        )

        expect do
          DebitCard.create!(
            card_number: card.card_number,
            expiration_month: card.expiration_month,
            expiration_year: card.expiration_year,
            cvv: 123,
            user_id: user.id
          )
        end.to raise_error(ActiveRecord::RecordInvalid, /Duplicate debit card record/)
      end

      it "does not fail to create a new card if there is another card with the same number but with a different expiration date" do
        card = DebitCard.create!(
          card_number: random_card_number,
          expiration_month: random_month,
          expiration_year: random_year,
          cvv: 123,
          user_id: user.id
        )

        expect do
          DebitCard.create!(
            card_number: card.card_number,
            expiration_month: random_month,
            expiration_year: random_year,
            cvv: 123,
            user_id: user.id
          )
        end.not_to raise_error
      end
    end
  end

  describe "user can have many debit cards" do
    it "allows the user to create multiple debit cards" do
      expect do
        2.times do
          DebitCard.create!(
            card_number: random_card_number,
            expiration_month: random_month,
            expiration_year: random_year,
            cvv: 123,
            user_id: user.id
          )
        end
      end.to change{DebitCard.count}.by(2)
    end
  end

end
