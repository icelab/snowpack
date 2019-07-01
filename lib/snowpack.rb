# frozen_string_literal: true

require_relative "snowpack/version"

module Snowpack
  @_mutex = Mutex.new

  def self.application
    @_mutex.synchronize do
      raise "Snowpack.application not configured" unless defined?(@_application)

      @_application
    end
  end

  def self.application?
    defined?(@_application) && @_application
  end

  def self.application=(klass)
    @_mutex.synchronize do
      raise "Snowpack.application already configured" if defined?(@_application)

      @_application = klass unless klass.name.nil?
    end
  end
end
