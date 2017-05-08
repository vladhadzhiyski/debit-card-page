module ApplicationHelper
  DEFAULT_ALERT = 'alert-dark'.freeze

  FLASHES = {
      'success' => 'alert-success',
      'info' => 'alert-info',
      'warning' => 'alert-warning',
      'error' => 'alert-danger'
    }.freeze

  def get_flash_class(type = nil)
    FLASHES[type].present? ? FLASHES[type] : DEFAULT_ALERT
  end

  def format_card_number(last_four)
    prefix = "*" * 12
    prefix + last_four
  end

  def format_expiration_month(month)
    month < 10 ? "0#{month}" : month
  end

  def format_card_expiration_date(month, year)
    month = format_expiration_month(month)
    "#{month}/#{year}"
  end
end
