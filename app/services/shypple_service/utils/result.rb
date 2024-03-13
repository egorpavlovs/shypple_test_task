class ShyppleService::Utils::Result
  attr_reader :value, :error

  def self.success(value = nil)
    new.success!(value)
  end

  def self.failure(error = nil)
    new.fail!(error)
  end

  def initialize
    @value = nil
    @error = nil
  end

  def success!(value)
    @value = value
    @error = nil
    self
  end

  def fail!(error)
    @value = nil
    @error = error
    self
  end

  def success?
    @error.nil?
  end

  def failure?
    @error.present?
  end
end
