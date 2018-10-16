require "appsignal"

Appsignal::Transaction.class_eval do
  def set_error_with_snowflakes(*args)
    restore!
    set_error_without_snowflakes(*args)
  end

  alias_method :set_error_without_snowflakes, :set_error
  alias_method :set_error, :set_error_with_snowflakes
end
