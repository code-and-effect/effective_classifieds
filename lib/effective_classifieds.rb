require 'effective_resources'
require 'effective_datatables'
require 'effective_classifieds/engine'
require 'effective_classifieds/version'

module EffectiveClassifieds

  def self.config_keys
    [
      :classifieds_table_name, :classified_submissions_table_name,
      :layout, :categories, :per_page, :use_effective_roles,
      :classified_submission_class_name
    ]
  end

  include EffectiveGem

  def self.ClassifiedSubmission
    classified_submission_class_name&.constantize || Effective::ClassifiedSubmission
  end

end
