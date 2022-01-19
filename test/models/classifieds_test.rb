require 'test_helper'

class ClassifiedsTest < ActiveSupport::TestCase
  test 'classified user' do
    user = build_user()
    assert user.valid?
  end

  test 'classified' do
    classified = build_classified()
    assert classified.valid?
    assert classified.save!

    assert classified.published?
    assert Effective::Classified.classifieds.include?(classified)
  end

  test 'classified published starts on' do
    classified = build_classified()
    classified.update!(start_on: Time.zone.now + 1.day)

    refute classified.published?
    refute Effective::Classified.classifieds.include?(classified)
  end

  test 'classified published ends on' do
    classified = build_classified()
    classified.update!(end_on: Time.zone.now)

    refute classified.published?
    refute Effective::Classified.classifieds.include?(classified)
  end

end
