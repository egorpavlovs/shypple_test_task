class ShyppleService::Strategies::CheapestDirect < ShyppleService::Strategies::Base
  def self.call(origin_port:, destination_port:)
    new(origin_port, destination_port).call
  end

  def initialize(origin_port, destination_port)
    @origin_port = origin_port
    @destination_port = destination_port
  end

  def call
    sailings = ShyppleService::Sailings.call(
      sailing_type: :direct, sailings: all_sailings,
      origin_port: origin_port, destination_port: destination_port
    )
    return sailings if sailings.failure?

    cheapest = sailings_with_rates(sailings).min_by { |sailing| sailing.first['current_rate'] }

    ShyppleService::Utils::Result.success([cheapest.first.except('current_rate')])
  end

private

  attr_reader :origin_port, :destination_port
end
