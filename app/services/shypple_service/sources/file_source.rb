class ShyppleService::Sources::FileSource
  FILE_PATH = Rails.root.join('app/services/shypple_service/sources/files/response.json').freeze

  def self.call
    new(FILE_PATH).call
  end

  def call
    ShyppleService::Utils::Result.success(JSON.parse(read))
  end

  def initialize(source)
    @source = source
  end

private

  attr_reader :source

  def read
    File.read(source)
  end
end
