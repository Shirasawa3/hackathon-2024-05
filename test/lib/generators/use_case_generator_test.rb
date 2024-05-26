require "test_helper"
require "generators/use_case/use_case_generator"

class UseCaseGeneratorTest < Rails::Generators::TestCase
  tests UseCaseGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
