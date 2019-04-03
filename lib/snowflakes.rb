require_relative "snowflakes/version"

module Snowflakes
  @_mutex = Mutex.new

  def self.application
    @_mutex.synchronize do
      raise "Snowflakes.application not configured" unless defined?(@_application)

      @_application
    end
  end

  def self.application=(klass)
    @_mutex.synchronize do
      raise "Snowflakes.application already configured" if defined?(@_application)

      @_application = klass unless klass.name.nil?
    end
  end
end
