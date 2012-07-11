Before do
  # Truncates the DB before each Scenario,
  # make sure you've added database_cleaner to your Gemfile.
  DatabaseCleaner.clean

  Factory(:role, :name => 'Admin')
  Factory(:role, :name => 'User')
end