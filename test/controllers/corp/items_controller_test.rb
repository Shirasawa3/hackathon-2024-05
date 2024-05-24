# frozen_string_literal: true

require 'test_helper'

class Corp::ItemsControllerTest < ActionDispatch::IntegrationTest
  describe '#index' do
    test 'returns a 200 response' do
      get corp_items_path
      assert_response :ok
    end
  end
end
