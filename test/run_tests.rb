base_dir = File.expand_path(File.join(File.dirname(__FILE__), ".."))
lib_dir  = File.join(base_dir, "lib")
test_dir = File.join(base_dir, "test")

$LOAD_PATH.unshift(lib_dir)

require 'test/unit'

puts "Starting test runner..."

# Require all test files in the test directory
Dir.glob("#{test_dir}/*_test.rb").each do |file|
  puts "Loading test file: #{file}"
  require file
end

puts "All test files loaded. Running tests..."

# Run the tests with verbose output
begin
  Test::Unit::AutoRunner.run
rescue => e
  puts "Error running tests: #{e.message}"
end