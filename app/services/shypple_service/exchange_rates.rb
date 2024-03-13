class ShyppleService::ExchangeRates
  def self.call(date:, currency:, exchange_rates:)
    new(date, currency, exchange_rates).call
  end

  def initialize(date, currency, exchange_rates)
    @date = date
    @currency = currency.downcase
    @exchange_rates = exchange_rates
  end

  def call
    rate_by_date = exchange_rates[date]

    return ShyppleService::Utils::Result.failure("No exchange rates found for date: #{date}") if rate_by_date.nil?
    if rate_by_date[currency].nil?
      return ShyppleService::Utils::Result.failure("No exchange rates found for currency: #{currency}")
    end

    ShyppleService::Utils::Result.success(rate_by_date[currency])
  end

private

  attr_reader :date, :currency, :exchange_rates
end
