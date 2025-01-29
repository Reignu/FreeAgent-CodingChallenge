# FreeAgent Coding Challenge - Currency Exchange Rate Calculator

## Coding Challenge Instructions

Please see the INSTRUCTIONS.md file for more information.

## Solution Setup and Run Instructions (Overview)

This project implements a currency exchange rate calculator that retrieves exchange rates from a specified data source (e.g. JSON) and calculates the exchange rate between two currencies on a given date.

### Prerequisites

To run this project, you need to have the following installed:

- Ruby (version 2.5 or higher)
- Bundler (for managing gem dependencies)

For Windows, you can download the installer from the [Ruby Downloads](https://www.ruby-lang.org/en/downloads/) page.

For macOS, you can install Ruby using Homebrew:
```zsh
brew install ruby
```

To install Bundler, run:
```bash
gem install bundler
```

### Testing Instructions
To run the tests, ensure that you have the necessary data file in the `data/` directory. Then execute:
```bash
bundle exec ruby test/run_tests.rb
```

### File Structure
```
coding-challenge-1.3/
├── lib/
│ ├── currency_exchange.rb # Main module for currency exchange logic
│ ├── exceptions.rb # Stores custom exceptions for raising errors
│ ├── logger.rb # Logger implementation to 
│ ├── exchange_rate_providers/
│ │ ├── base_provider.rb # Abstract base class for exchange rate providers
│ │ ├── json_provider.rb # JSON provider for fetching exchange rates
│ │ └── xml_provider.rb # XML provider for fetching exchange rates (not implemented, just an example)
├── test/
│ ├── currency_exchange_test.rb # Unit tests for the currency exchange functionality
│ └── run_tests.rb # Script to run all tests
├── data/
│ └── exchange_rates.json # JSON file containing exchange rates (renamed from the original file for clarity)
├── config.yml # Configuration file for provider settings
├── Gemfile # Gem dependencies for the project
├── INSTRUCTIONS.md # Instructions for the coding challenge
├── README.md
└── .gitignore
```

### Usage Examples
To calculate the exchange rate between two currencies, you can use the following command in the Ruby console (adjust values for date and currency as required):
```ruby
require 'date'
require_relative './lib/currency_exchange'
rate = CurrencyExchange.rate(Date.new(2018, 11, 22), "USD", "GBP", provider)
puts "Exchange rate from USD to GBP on 2018-11-22: #{rate}"
```

## Design and Implementation

This section outlines the key design decisions made during the development of the application and how they are implemented.

1. **Provider Pattern**: The implementation uses the provider pattern to allow for flexibility in the data source. This design enables easy switching between different sources of exchange rates (e.g., JSON, XML) without changing the core logic of the application.

2. **Base Currency**: The application allows for a configurable base currency, which can be specified in the `config.yml` file. This decision aligns with the requirements and enhances flexibility.

3. **Error Handling**: The code raises custom exceptions for various error conditions, such as unsupported currencies (`CurrencyNotFoundError`) or missing rates for a given date (`RateNotAvailableError`). This ensures that the application fails gracefully and provides meaningful error messages, improving maintainability and clarity.

4. **Logging**: The application uses Ruby's built-in `Logger` class to track application behavior and errors. Key events, such as fetching rates and calculating exchange rates, are logged to help with debugging and understanding application behavior.

5. **Configuration Validation**: The application includes a configuration validation method to ensure that the `config.yml` file contains all required fields and that they are correctly formatted. This validation helps prevent runtime errors by ensuring that the application is configured correctly before it runs.
    - Required Keys: The configuration must include the following keys: `provider`, `file_path`, and `base_currency`. If any of these keys are missing, an error will be raised.
    - Provider Validation: The specified provider must be either `json` or `xml`. If an invalid provider is specified, an error will be raised.

6. **Exchange Rate Calculation**: The `CurrencyExchange.rate` method retrieves the exchange rates for the specified date using the selected provider. It then calculates the exchange rate between the two currencies based on the retrieved rates.

7. **Testing**: The tests are written using the `Test::Unit` framework. The `currency_exchange_test.rb` file contains tests for both base and non-base currency exchanges, ensuring that the expected rates match the calculated rates.<br>
    In addition to standard tests, edge case tests have been implemented to cover potential failure scenarios, including:
    - **Invalid Currency Codes**: Tests that the application raises a `CurrencyNotFoundError` when an invalid currency code is provided.
    - **Dates with No Available Rates**: Tests that the application raises a `RateNotAvailableError` when a date is requested for which no rates are available.
    - **Base Currency Not in Rates**: Tests that the application raises a `CurrencyNotFoundError` when the base currency is not present in the fetched rates.

8. **XML Provider**: The `xml_provider.rb` file is included as a placeholder for future implementation. It is designed to fetch exchange rates from XML data sources, allowing the application to support additional formats beyond JSON.

## Future Improvement ideas

- Additional data sources: XML, CSV, etc.
- API implementation: integrate to allow other applications to access the currency exchange functionality
- Caching: implement to store rates temporarily to reduce the number of requests made and improve performance

## Questions
- What other sources would you consider pulling data from apart from JSON and XML, maybe an API or otherwise?
- How would you approach scaling this sort of application in line with Freeagent's Engineering values?

## Note on Experience

I would like to note that I have not coded in Ruby before this project. However, I have experience in other programming languages namely Python and Java and I also referred to Ruby docs which helped me understand Ruby's syntax and conventions quickly. I felt that from a developer's perspective, the language is enjoyable to write but sometimes it took me extra time to execute the logic so that it is understood by the machine.

I approached this challenge with a focus on clean code, modular design, and thorough testing. Moving forward, I am eager to continue learning Ruby and exploring its ecosystem, particularly in the context of web development and API design.
