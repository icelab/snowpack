# frozen_string_literal: true

require "appsignal"

Appsignal::Transaction.class_eval do
  def set_error_with_snowpack(*args)
    restore!
    set_error_without_snowpack(*args)
  end

  alias_method :set_error_without_snowpack, :set_error
  alias_method :set_error, :set_error_with_snowpack
end
