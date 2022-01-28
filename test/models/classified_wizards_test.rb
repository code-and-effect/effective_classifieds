require 'test_helper'

class ClassifiedWizardsTest < ActiveSupport::TestCase
  test 'build_classified_wizard is valid' do
    submission = build_classified_wizard()
    assert submission.valid?
    submission.save!

    assert submission.draft?

    assert submission.classified.present?
    assert submission.classified.valid?
    assert submission.classified.draft?
  end

  test 'submit' do
    submission = build_classified_wizard()
    submission.save!

    assert_email do
      EffectiveResources.transaction { submission.submit! }
    end

    assert submission.submitted?
    assert submission.classified.submitted?
    refute submission.classified.published?
  end

  test 'submit with auto approve' do
    submission = build_classified_wizard()
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
