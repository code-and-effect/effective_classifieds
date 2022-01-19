require 'test_helper'

class ClassifiedSubmissionsTest < ActiveSupport::TestCase
  test 'build_classified_submission is valid' do
    submission = build_classified_submission()
    assert submission.valid?
    submission.save!

    assert submission.draft?

    assert submission.classified.present?
    assert submission.classified.valid?
    assert submission.classified.draft?
  end

  test 'submit' do
    submission = build_classified_submission()
    submission.save!

    assert_email do
      EffectiveResources.transaction { submission.submit! }
    end

    assert submission.submitted?
    assert submission.classified.submitted?
    refute submission.classified.published?
  end

  test 'submit with auto approve' do
    submission = build_classified_submission()
    submission.save!

    existing = EffectiveClassifieds.auto_approve

    begin
      EffectiveClassifieds.auto_approve = true

      assert_email do
        EffectiveResources.transaction { submission.submit! }
      end

    ensure
      EffectiveClassifieds.auto_approve = existing
    end

    assert submission.submitted?
    assert submission.classified.approved?
    assert submission.classified.published?
  end

end
