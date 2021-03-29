require 'database_cleaner'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation

    # Only delete the "users" collection.
    # DatabaseCleaner[:mongoid].strategy = :deletion, { only: ["users"] }

    # Delete all collections except the "users" collection.
    # DatabaseCleaner[:mongoid].strategy = :deletion, { except: ["users"] }
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
