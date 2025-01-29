require 'logger'

module CurrencyExchange
  def self.logger
    @logger ||= Logger.new(STDOUT) # Log to standard output
  end
end