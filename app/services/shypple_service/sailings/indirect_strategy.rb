class ShyppleService::Sailings::IndirectStrategy
  def self.call(origin_port, destination_port, sailings)
    new(origin_port, destination_port, sailings).call
  end

  def initialize(origin_port, destination_port, sailings)
    @origin_port = origin_port
    @destination_port = destination_port
    @sailings = sailings
    @result = []
  end

  def call
    origin_port_sailings = sailings.select { |sailing| sailing[:origin_port] == origin_port }
    origin_port_sailings.each do |origin_port_sailing|
      find_suitable_sailings(origin_port_sailing, [])
    end

    if @result.empty?
      ShyppleService::Utils::Result.failure("No suitable sailings found for #{origin_port} -> #{destination_port} route.")
    else
      ShyppleService::Utils::Result.success(@result)
    end
  end

private

  attr_reader :origin_port, :destination_port, :sailings

  def find_suitable_sailings(current_sailing, result_path = [])
    result_path << current_sailing
    if current_sailing[:destination_port] == destination_port
      @result << result_path
      return
    end

    (sailings - result_path).each do |sailing|
      unless sailing[:origin_port] == current_sailing[:destination_port] &&
          sailing[:departure_date] > current_sailing[:arrival_date]
        next
      end

      find_suitable_sailings(sailing, result_path.clone)
    end
  end
end
