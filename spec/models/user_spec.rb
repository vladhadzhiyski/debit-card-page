require 'rails_helper'

RSpec.describe User, type: :model do
  describe "success" do
    it "creates a user if first and last name are provided" do
      expect do
        User.create!(
          first_name: "Al",
          last_name: "Pacino"
        )
      end.to change{User.count}.by(1)

      user = User.last
      expect(user.first_name).to eq("Al")
      expect(user.last_name).to eq("Pacino")
      expect(user.permalink).to eq("al-pacino")
    end

    it "updates the user if first or last name are updated" do
      user = User.create(
        first_name: "Al",
        last_name: "Pacino"
      )
      user.update!(
        first_name: "Albert",
        last_name: "Pacino"
      )

      user.reload
      expect(user.first_name).to eq("Albert")
      expect(user.last_name).to eq("Pacino")
      expect(user.permalink).to eq("albert-pacino")
    end
  end

  describe "failures" do
    it "does not create a user if first name is missing" do
      expect do
        User.create!(
          last_name: "Pacino"
        )
      end.to raise_error(ActiveRecord::RecordInvalid, /First name can't be blank/)
    end

    it "does not create a user if last name is missing" do
      expect do
        User.create!(
          first_name: "Al"
        )
      end.to raise_error(ActiveRecord::RecordInvalid, /Last name can't be blank/)
    end

    it "does not create a user if the user already exists" do
      user = User.create!(
        first_name: "Al",
        last_name: "Pacino"
      )
      expect do
        User.create!(
          first_name: "Al",
          last_name: "Pacino"
        )
      end.to raise_error(ActiveRecord::RecordInvalid, /Validation failed: This user is already registered/)
    end
  end
end
