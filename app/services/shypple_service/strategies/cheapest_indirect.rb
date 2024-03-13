class ShyppleService::Strategies::CheapestIndirect < ShyppleService::Strategies::Base
  def self.call(origin_port:, destination_port:)
    new(origin_port, destination_port).call
  end

  def initialize(origin_port, destination_port)
    @origin_port = origin_port
    @destination_port = destination_port
  end

  def call
    sailings = ShyppleService::Sailings.call(
      sailing_type: :indirect, sailings: all_sailings,
      origin_port: origin_port, destination_port: destination_port
    )
    return sailings if sailings.failure?

    rate = 0
    cheapest = nil

    sailings_with_rates(sailings).each do |sailing|
      sailing_rate_sum = sailing.pluck('current_rate').sum
      next unless rate.zero? || sailing_rate_sum < rate

      rate = sailing_rate_sum
      sailing.each do |sailing_part|
        sailing_part.except!('current_rate')
      end
      cheapest = sailing
    end

    ShyppleService::Utils::Result.success(cheapest)
  end

private

  attr_reader :origin_port, :destination_port
end
