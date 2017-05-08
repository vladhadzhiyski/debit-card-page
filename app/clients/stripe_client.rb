class StripeClient
  def self.payment_amount(user_id, amount)
    body = { amount: amount }.to_json
    response = RestClient.post("#{host}/users/#{user_id}/payment", body, headers)
    JSON.parse(response)
  end

  def self.host
    Settings[Rails.env][:stripe_host] || "http://stripe-host"
  end

  def self.api_key
    Settings[Rails.env][:stripe_api_key] || "stripe-api-key"
  end

  def self.headers
    {content_type: :json, accept: :json}.merge("STRIPE_API_KEY" => api_key)
  end
end
