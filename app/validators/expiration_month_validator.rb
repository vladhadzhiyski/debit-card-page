class ExpirationMonthValidator < ActiveModel::Validator
  def validate(record)
    if record.expiration_month.present?
      record.errors.add(:base, "Expiration month must be between 1 and 12") unless record.expiration_month.between?(1, 12)
    end
  end
end
