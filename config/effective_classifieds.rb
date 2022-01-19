EffectiveClassifieds.setup do |config|
  config.classifieds_table_name = :classifieds
  config.classified_submissions_table_name = :classified_submissions

  # Every classified must have a category.
  config.categories = ['Job Board', 'Equipment Sales']

  # Layout Settings
  # Configure the Layout per controller, or all at once
  # config.layout = { application: 'application', admin: 'admin' }

  # Classified Settings
  # config.classified_submission_class_name = 'Effective::ClassifiedSubmission'

  # Pagination length on the Classified#index page
  config.per_page = 10

  # Classified can be restricted by role
  config.use_effective_roles = true

  # Automatically end classifieds after this duration
  config.max_duration = 3.months

  # Automatically approve classified submissions, otherwise require admin approval
  config.auto_approve = true
end
