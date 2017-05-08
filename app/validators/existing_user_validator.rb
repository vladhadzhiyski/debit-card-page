class ExistingUserValidator < ActiveModel::Validator
  def validate(record)
    if user_exists?(record)
      record.errors.add(:base, "This user is already registered")
    end
  end

  private

    def user_exists?(record)
      User.find_by_permalink(record.permalink).present?
    end
end
