# lib/currency_exchange.rb
require 'json'
require_relative './exchange_rate_providers/json_provider'
require_relative './logger'

module CurrencyExchange

  # Return the exchange rate between from_currency and to_currency on date as a float.
  # Raises an exception if unable to calculate requested rate.
  # Raises an exception if there is no rate for the date provided.
  def self.rate(date, from_currency, to_currency, provider)
    rates = provider.fetch_rates(date)

    # Use the base currency from the provider's configuration
    base_currency = provider.base_currency || 'EUR' # Default to EUR if not found

    # Get rates for the requested currencies
    from_rate = rates[from_currency] || (1.0 / rates[base_currency]) # Convert from_currency to EUR(base) if needed
    to_rate = rates[to_currency] || 1.0 # Base currency to base currency is 1.0

    # Log the rates being used
    logger.info("Calculating exchange rate from #{from_currency} to #{to_currency} using base currency #{base_currency}")

    # Use custom exceptions for raising errors
    raise CurrencyNotFoundError, "Currency #{from_currency} not supported" unless from_rate
    raise CurrencyNotFoundError, "Currency #{to_currency} not supported" unless to_rate

    # Calculate the exchange rate
    exchange_rate = (to_rate / from_rate).to_f
    logger.info("Calculated exchange rate: #{exchange_rate}")
    
    exchange_rate
  end

  def self.validate_config(config)
    required_keys = ['provider', 'file_path', 'base_currency']
    missing_keys = required_keys.select { |key| !config.key?(key) }

    unless missing_keys.empty?
      raise "Missing required configuration keys: #{missing_keys.join(', ')}"
    end

    unless ['json', 'xml'].include?(config['provider'])
      raise "Invalid provider specified: #{config['provider']}. Must be 'json' or 'xml'."
    end
  end

end
