# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # db/fixtures/*.yml を読み込ませる
  def before_setup
    super

    ActiveRecord::FixtureSet.create_fixtures(Rails.root.join('db/fixtures'),
                                             Dir.glob('*.yml',
                                                      base: Rails.root.join('db/fixtures'))
                                                .map { |f| f.sub('.yml', '') })
  end

  def before_teardown
    super

    ActiveRecord::FixtureSet.reset_cache
  end

  # Add more helper methods to be used by all tests here...
  def self.describe(description)
    return unless block_given?

    @names ||= []
    @names << description
    yield
    @names.pop
  end

  def self.context(description)
    return unless block_given?

    @names ||= []
    @names << description
    yield
    @names.pop
  end

  def self.test(description, &test_process)
    @names ||= []
    @names << description
    test_method = test_process || proc do
      skip
    end
    result = super(@names.compact.join(' '), &test_method)
    @names.pop
    result
  end
end
