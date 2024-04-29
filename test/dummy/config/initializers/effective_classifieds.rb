EffectiveClassifieds.setup do |config|
  # Every classified must have a category.
  config.categories = ['Job', 'Equipment Sales', 'Other']

  # Layout Settings
  # Configure the Layout per controller, or all at once
  # config.layout = { application: 'application', admin: 'admin' }

  # Classified Settings
  config.classified_wizard_class_name = 'ClassifiedWizard'

  # Pagination length on the Classified#index page
  config.per_page = 12

  # Classified can be restricted by role
  config.use_effective_roles = true

  # Automatically end classifieds after this duration
  config.max_duration = 3.months

  # Automatically approve classified ad submissions, otherwise require admin approval
  config.auto_approve = false

  # Can checkout with phone or cheque 'deferred' payment providers
  config.skip_deferred = true

  # Mailer Settings
  # Please see config/initializers/effective_resources.rb for default effective_* gem mailer settings
  #
  # Configure the class responsible to send e-mails.
  # config.mailer = 'Effective::ClassifiedsMailer'
  #
  # Override effective_resource mailer defaults
  #
  # config.parent_mailer = nil      # The parent class responsible for sending emails
  # config.deliver_method = nil     # The deliver method, deliver_later or deliver_now
  # config.mailer_layout = nil      # Default mailer layout
  # config.mailer_sender = nil      # Default From value
  # config.mailer_admin = nil       # Default To value for Admin correspondence
  # config.mailer_subject = nil     # Proc.new method used to customize Subject
end
