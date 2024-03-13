class ShyppleService::Strategies::Base
  DEFAULT_CURRENCY = 'EUR'.freeze

  def self.call(*_args)
    raise NotImplementedError
  end

private

  def all_sailings
    information['sailings']
  end

  def all_rates
    information['rates']
  end

  def all_exchange_rates
    information['exchange_rates']
  end

  def information
    @information ||= ShyppleService::GetInformation.call(:file).value.with_indifferent_access
  end

  def sailings_with_rates(sailings)
    sailings.value.map do |sailing|
      sailing.map do |sailing_track|
        rate = ShyppleService::Rates.call(sailing: sailing_track, rates: all_rates)
        next sailing_track if rate.failure?

        sailing_track.merge!(rate.value)
        current_rate = if sailing_track['rate_currency'] == DEFAULT_CURRENCY
          rate.value['rate'].to_f
        else
          current_exchange_rate = exchange_rate(
            sailing_track['departure_date'], rate.value['rate_currency']
          )
          next sailing_track if current_exchange_rate.failure?

          (rate.value['rate'].to_f * current_exchange_rate.value).round(2)
        end

        sailing_track.merge(
          'current_rate' => current_rate
        )
      end
    end
  end

  def exchange_rate(date, currency)
    ShyppleService::ExchangeRates.call(
      date: date,
      currency: currency,
      exchange_rates: all_exchange_rates
    )
  end
end
