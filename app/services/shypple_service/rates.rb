class ShyppleService::Rates
  def self.call(sailing:, rates:)
    new(sailing, rates).call
  end

  def initialize(sailing, rates)
    @sailing = sailing
    @rates = rates
  end

  def call
    sailing_code = sailing['sailing_code']
    rate = rates.find { |r| r['sailing_code'] == sailing_code }

    return ShyppleService::Utils::Result.failure("No rate found for sailing: #{sailing_code}") if rate.nil?

    ShyppleService::Utils::Result.success(rate)
  end

private

  attr_reader :sailing, :rates
end
