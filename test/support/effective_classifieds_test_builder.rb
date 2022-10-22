module EffectiveClassifiedsTestBuilder

  def create_user!
    build_user.tap { |user| user.save! }
  end

  def build_user
    @user_index ||= 0
    @user_index += 1

    User.new(
      email: "user#{@user_index}@example.com",
      password: 'rubicon2020',
      password_confirmation: 'rubicon2020',
      first_name: 'Test',
      last_name: 'User'
    )
  end

  def build_classified(owner: nil)
    owner ||= build_user()

    Effective::Classified.new(
      owner: owner,
      title: 'A Classified Ad',
      body: '<p>A cool job</p>',
      category: EffectiveClassifieds.categories.first,
      organization: 'Adams Restaurant',
      location: 'California',
      email: 'someone@example.com',
      phone: '(444) 444-4444',
      start_on: Time.zone.now,
      end_on: (Time.zone.now + 7.days)
    )
  end

  def build_classified_wizard(classified: nil)
    classified ||= build_classified()

    wizard = Effective::ClassifiedWizard.new(owner: classified.owner)
    wizard.classifieds << classified

    wizard
  end

  def build_submitted_classified_wizard(classified: nil)
    classified_wizard = build_classified_wizard(classified: classified)

    classified_wizard.ready!
    classified_wizard.submit_order.purchase!
    classified_wizard.reload
    classified_wizard
  end

end
