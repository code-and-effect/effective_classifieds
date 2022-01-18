require 'test_helper'

class ClassifiedsTest < ActiveSupport::TestCase
  test 'classified user' do
    user = build_user()
    assert user.valid?
  end

end
