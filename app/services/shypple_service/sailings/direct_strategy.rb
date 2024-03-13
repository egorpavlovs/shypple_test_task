class ShyppleService::Sailings::DirectStrategy
  def self.call(origin_port, destination_port, sailings)
    new(origin_port, destination_port, sailings).call
  end

  def initialize(origin_port, destination_port, sailings)
    @origin_port = origin_port
    @destination_port = destination_port
    @sailings = sailings
  end

  def call
    suitable_sailings = sailings.select do |sailing|
      sailing['origin_port'] == origin_port && sailing['destination_port'] == destination_port
    end

    if suitable_sailings.empty?
      ShyppleService::Utils::Result.failure(
        "No suitable sailings found for #{origin_port} - #{destination_port}"
      )
    else
      ShyppleService::Utils::Result.success(suitable_sailings.map { |sailing| [sailing] })
    end
  end

private

  attr_reader :origin_port, :destination_port, :sailings
end
