class ShyppleService::Sailings
  REGISTRY = {
    direct: ShyppleService::Sailings::DirectStrategy,
    indirect: ShyppleService::Sailings::IndirectStrategy
  }.freeze

  def self.call(sailing_type:, sailings:, origin_port:, destination_port:)
    new(sailing_type, sailings, origin_port, destination_port).call
  end

  def initialize(sailing_type, sailings, origin_port, destination_port)
    @sailing_type = sailing_type
    @sailings = sailings
    @origin_port = origin_port
    @destination_port = destination_port
  end

  def call
    currrent_strategy = REGISTRY[sailing_type]
    if currrent_strategy
      currrent_strategy.call(origin_port, destination_port, sailings)
    else
      ShyppleService::Utils::Result.failure("Unknown sailing type: #{sailing_type}")
    end
  end

private

  attr_reader :sailing_type, :sailings, :origin_port, :destination_port
end
