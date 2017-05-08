class User < ApplicationRecord
  include ActiveModel::Validations

  validates_presence_of :first_name, :last_name
  validates_with ExistingUserValidator

  before_validation(on: :create) do
    self.permalink ||= build_permalink
  end

  before_validation(on: :update) do
    self.permalink = build_permalink
  end

  has_many :debit_cards

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  private

    def build_permalink
      full_name.parameterize
    end
end
