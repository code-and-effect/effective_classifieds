EffectiveClassifieds.setup do |config|
  config.classifieds_table_name = :classifieds
  config.classified_wizards_table_name = :classified_wizards

  # Every classified must have a category.
  config.categories = ['Job', 'Equipment Sales', 'Other']

  # Layout Settings
  # Configure the Layout per controller, or all at once
  # config.layout = { application: 'application', admin: 'admin' }

  # Classified Settings
  # config.classified_wizard_class_name = 'Effective::ClassifiedWizard'

  # Pagination length on the Classified#index page
  config.per_page = :all

  # Classified can be restricted by role
  config.use_effective_roles = true

  # Automatically end classifieds after this duration
  config.max_duration = 3.months

  # Automatically approve classified ad submissions, otherwise require admin approval
  config.auto_approve = false

  # Mailer Configuration
  # Configure the class responsible to send e-mails.
  # config.mailer = 'Effective::ClassifiedsMailer'

  # Configure the parent class responsible to send e-mails.
  # config.parent_mailer = 'ActionMailer::Base'

  # Default deliver method
  # config.deliver_method = :deliver_later

  # Default layout
  # config.mailer_layout = 'effective_classifieds_mailer_layout'

  # Default From
  config.mailer_sender = "no-reply@example.com"

  # Send Admin correspondence To
  config.mailer_admin = "admin@example.com"
end
