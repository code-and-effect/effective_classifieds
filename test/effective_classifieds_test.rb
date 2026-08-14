require "test_helper"

class EffectiveClassifiedsTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert EffectiveClassifieds::VERSION
  end

  test 'uses the configured classified wizard' do
    assert_equal ClassifiedWizard, EffectiveClassifieds.ClassifiedWizard
  end
end
