require 'test_helper'

class Effective::ClassifiedsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  tests Effective::ClassifiedsController

  setup do
    @routes = EffectiveClassifieds::Engine.routes
  end

  test 'invalid page raises record not found before rendering' do
    error = assert_raises(ActiveRecord::RecordNotFound) do
      get :index, params: { page: 'invalid' }
    end

    assert_equal 'Page "invalid" is invalid', error.message
  end

  test 'out of range page raises record not found before rendering' do
    error = assert_raises(ActiveRecord::RecordNotFound) do
      get :index, params: { page: 2 }
    end

    assert_equal 'Page 2 does not exist', error.message
  end

  test 'valid page renders paginated classifieds with the cached count' do
    (EffectiveClassifieds.per_page + 1).times do |index|
      build_classified.tap do |classified|
        classified.title = "Classified #{index}"
        classified.save!
      end
    end

    get :index, params: { page: 2 }

    assert_response :success
    assert_equal EffectiveClassifieds.per_page + 1, @controller.instance_variable_get(:@classifieds_count)
    assert_equal 1, @controller.instance_variable_get(:@classifieds).size
    assert_select '.pagination'
  end
end
