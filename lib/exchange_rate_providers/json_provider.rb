# lib/exchange_rate_providers/json_provider.rb
require 'json'
require 'date'
require_relative './base_provider'
require_relative './logger'

module ExchangeRateProviders
  class JsonProvider < BaseProvider
    def initialize(file_path)
      @file_path = file_path
      @data = JSON.parse(File.read(@file_path))
    end

    def fetch_rates(date)
      date_str = date.strftime('%Y-%m-%d')
      logger.info("Fetching rates for date: #{date_str}")
      rates = @data[date_str]

      # Handle missing date
      raise "No rates available for #{date_str}" unless rates

      rates
    end
  end
end