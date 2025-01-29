module ExchangeRateProviders
  class BaseProvider
    def fetch_rates(date)
      raise NotImplementedError, 'Subclasses must implement fetch_rates'
    end
  end
end