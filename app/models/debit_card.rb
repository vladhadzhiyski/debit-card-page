class DebitCard < ApplicationRecord
  include ActiveModel::Validations

  before_validation :find_last_four

  validates_presence_of :card_number, :expiration_month, :expiration_year, :cvv, :user_id
  validates_with ExpirationMonthValidator, DuplicateCardValidator

  belongs_to :user

  attr_encrypted :card_number, key: 'a' * 32

  def stub_perform_payment(amount)
    card_number == '4242424242424242' ? '100' : '203'
  end

  private

    def find_last_four
      self.last_four = self.card_number.last(4) if self.card_number.present?
    end

end
