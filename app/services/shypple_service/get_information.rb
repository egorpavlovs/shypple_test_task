class ShyppleService::GetInformation
  REGISTRY = {
    file: ShyppleService::Sources::FileSource
    # TODO: add HTTP requers to MapReduce service url
    # map_reduce_service: ShyppleService::Sources::MapReduceService
  }
  def self.call(source_type)
    new(source_type).call
  end

  def initialize(source_type)
    @source_type = source_type
  end

  def call
    source = REGISTRY[source_type.to_sym]
    if source
      source.call
    else
      ShyppleService::Utils::Result.failure("Unknown source type: #{source_type}")
    end
  end

private

  attr_reader :source_type
end
