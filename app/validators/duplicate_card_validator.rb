class DuplicateCardValidator < ActiveModel::Validator
  def validate(record)
    if duplicate?(record)
      record.errors.add(:base, "Duplicate debit card record")
    end
  end

  private

    def duplicate?(record)
      DebitCard.where(last_four: record.last_four, expiration_month: record.expiration_month, expiration_year: record.expiration_year).present?
    end
end
