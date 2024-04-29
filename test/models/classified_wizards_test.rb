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
    classified_wizard = build_classified_wizard()
    classified_wizard.save!

    classified_wizard.ready!

    # Invoices and submitted email
    assert_email(count: 3) do
      classified_wizard.submit_order.purchase!
    end

    classified_wizard.reload

    assert classified_wizard.submitted?
    assert classified_wizard.classified.submitted?
    refute classified_wizard.classified.published?
  end

  test 'submit with auto approve' do
    classified_wizard = build_classified_wizard()
    classified_wizard.save!
    classified_wizard.ready!

    existing = EffectiveClassifieds.auto_approve

    begin
      EffectiveClassifieds.auto_approve = true

      assert_email do
        classified_wizard.submit_order.purchase!
      end

    ensure
      EffectiveClassifieds.auto_approve = existing
    end

    classified_wizard.reload

    assert classified_wizard.submitted?
    assert classified_wizard.classified.approved?
    assert classified_wizard.classified.published?
  end

end
