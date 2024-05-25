# frozen_string_literal: true

require 'test_helper'

class Corp::ItemsControllerTest < ActionDispatch::IntegrationTest
  describe '#index' do
    context 'as a guest' do
      test 'returns 302 response'
      test 'redirects to sign in page'
    end

    context 'as a user' do
      test 'returns a 200 response' do
        get corp_items_path
        assert_response :ok
      end
    end
  end

  describe '#show' do
    context 'as a guest' do
      test 'returns 302 response'
      test 'redirects to sign in page'
    end

    context 'as a user' do
      context 'when item exists' do
        test 'returns a 200 response' do
          ItemBasicInfo.create!(id: 1, item_type_id: 1, name: 'Item', count: 1)
          get corp_item_path(1)

          assert_response :ok
        end
      end

      context 'when item does not exist' do
        test 'returns a 302 response' do
          get corp_item_path(1)

          assert_response :found
        end

        test 'redirects to #index' do
          get corp_item_path(1)

          assert_redirected_to corp_items_path
        end
      end
    end
  end

  describe '#new' do
    context 'as a guest' do
      test 'returns 302 response'
      test 'redirects to sign in page'
    end

    context 'as a user' do
      test 'returns a 200 response' do
        get new_corp_item_path
        assert_response :ok
      end
    end
  end

  describe '#edit' do
    context 'as a guest' do
      test 'returns 302 response'
      test 'redirects to sign in page'
    end

    context 'as a user' do
      context 'when item exists' do
        test 'returns a 200 response' do
          ItemBasicInfo.create!(id: 1, item_type_id: 1, name: 'Item', count: 1)
          get edit_corp_item_path(1)

          assert_response :ok
        end
      end

      context 'when item does not exist' do
        test 'returns a 302 response' do
          get edit_corp_item_path(1)

          assert_response :found
        end

        test 'redirects to #index' do
          get edit_corp_item_path(1)

          assert_redirected_to corp_items_path
        end
      end
    end
  end

  describe '#create' do
    context 'as a guest' do
      test 'returns 302 response'
      test 'redirects to sign in page'
    end

    context 'as a user' do
      context 'when params are invalid' do
        test 'returns 422 response' do
          post corp_items_path, params: { item: { name: '' } }

          assert_response :unprocessable_entity
        end
      end

      context 'when params are valid' do
        test 'returns 302 response' do
          post corp_items_path, params: { item: { name: 'bible', item_type_id: 1, count: 13 } }

          assert_response :found
        end

        test 'redirects to #index' do
          post corp_items_path, params: { item: { name: 'bible', item_type_id: 1, count: 13 } }

          assert_redirected_to corp_items_path
        end
      end
    end
  end

  describe '#update' do
    context 'as a guest' do
      test 'returns 302 response'
      test 'redirects to sign in page'
    end

    context 'as a user' do
      context 'when params are invalid' do
        test 'returns 422 response' do
          ItemBasicInfo.create!(id: 1, item_type_id: 1, name: 'bible', count: 13)
          patch corp_item_path(1), params: { item: { name: '' } }

          assert_response :unprocessable_entity
        end
      end

      context 'when params are valid' do
        test 'returns 302 response' do
          ItemBasicInfo.create!(id: 1, item_type_id: 1, name: 'bible', count: 13)
          patch corp_item_path(1), params: { item: { count: 1 } }

          assert_response :found
        end

        test 'redirects to #show' do
          ItemBasicInfo.create!(id: 1, item_type_id: 1, name: 'bible', count: 13)
          patch corp_item_path(1), params: { item: { count: 1 } }

          assert_redirected_to corp_items_path(1)
        end

        test 'update specified columns' do
          item = ItemBasicInfo.create!(id: 1, item_type_id: 1, name: 'bible', count: 13)
          patch corp_item_path(1), params: { item: { count: 1, max_lent_period: '0/0/1' } }
          item.reload

          assert_equal 1, item.count
          assert_equal 1.day, item.max_lent_period
        end
      end

      test 'can update tags to count' do
        item = ItemBasicInfo.create!(id: 1, item_type_id: 1, name: 'bible', count: 13)
        patch corp_item_path(1), params: { item: { tags: "tag1\ntag2\n" } }
        item.reload

        assert_nil item.count
        assert_equal %w[tag1 tag2], item.tags
      end

      test 'can update count to tags' do
        item = ItemBasicInfo.create!(id: 1, item_type_id: 1, name: 'bible', tags: %w[tag1 tag2])
        patch corp_item_path(1), params: { item: { count: 13 } }
        item.reload

        assert_nil item.tags
        assert_equal 13, item.count
      end
    end
  end
end
