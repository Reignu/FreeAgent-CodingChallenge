# These are just suggested definitions to get you started.  Please feel
# free to make any changes at all as you see fit.


# http://test-unit.github.io/
require 'test/unit'
require_relative '../lib/currency_exchange'
require 'date'
require_relative '../lib/exchange_rate_providers/json_provider'
require 'yaml'

class CurrencyExchangeTest < Test::Unit::TestCase
  def setup
    config = YAML.load_file('config.yml')
    CurrencyExchange.validate_config(config) # Validate the configuration
    @provider = case config['provider']
                when 'json'
                  ExchangeRateProviders::JsonProvider.new(config['file_path'])
                when 'xml'
                  ExchangeRateProviders::XmlProvider.new(config['file_path'])
                else
                  raise "Unknown provider: #{config['provider']}"
                end
    @provider.base_currency = config['base_currency'] # Set the base currency
  end

  def test_non_base_currency_exchange_is_correct
    puts "Running test_non_base_currency_exchange_is_correct"  # Debug line
    correct_rate = 1.2870493690602498
    assert_equal correct_rate, CurrencyExchange.rate(Date.new(2018,11,22), "GBP", "USD", @provider)
  end

  def test_base_currency_exchange_is_correct
    puts "Running test_base_currency_exchange_is_correct"  # Debug line
    correct_rate = 0.007763975155279502
    assert_equal correct_rate, CurrencyExchange.rate(Date.new(2018,11,22), "JPY", "EUR", @provider)
  end

  def test_invalid_currency_code
    assert_raises(CurrencyNotFoundError) do
      CurrencyExchange.rate(Date.new(2018, 11, 22), "INVALID", "USD", @provider)
    end
  end

  def test_date_with_no_rates
    # JSON data does not have rates for this date
    assert_raises(RateNotAvailableError) do
      CurrencyExchange.rate(Date.new(2020, 1, 1), "GBP", "USD", @provider)
    end
  end

  def test_base_currency_not_in_rates
    # The base currency is set different to base currency
    config['base_currency'] = 'INVALID'
    @provider = ExchangeRateProviders::JsonProvider.new(config['file_path'])
    assert_raises(CurrencyNotFoundError) do
      CurrencyExchange.rate(Date.new(2018, 11, 22), "GBP", "USD", @provider)
    end
  end
end
