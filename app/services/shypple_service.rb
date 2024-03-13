class ShyppleService
  REGISTRY = {
    'PLS-0001' => ShyppleService::Strategies::CheapestDirect,
    'WRT-0002' => ShyppleService::Strategies::CheapestIndirect,
    'TST-0003' => nil
  }.freeze

  def self.call(strategy:, origin_port:, destination_port:)
    new(strategy, origin_port, destination_port).call
  end

  def initialize(strategy, origin_port, destination_port)
    @strategy = strategy
    @origin_port = origin_port
    @destination_port = destination_port
  end

  def call
    current_strategy = REGISTRY[strategy]
    return ShyppleService::Utils::Result.failure("Invalid #{strategy} strategy") if current_strategy.nil?

    current_strategy.call(origin_port: origin_port, destination_port: destination_port)
  end

private

  attr_reader :strategy, :origin_port, :destination_port
end
