require 'effective_resources'
require 'effective_datatables'
require 'effective_classifieds/engine'
require 'effective_classifieds/version'

module EffectiveClassifieds

  def self.config_keys
    [
      :classifieds_table_name, :classified_wizards_table_name,
      :mailer, :parent_mailer, :deliver_method, :mailer_layout, :mailer_sender, :mailer_admin, :mailer_subject,
      :layout, :categories, :per_page, :use_effective_roles, :max_duration, :auto_approve,
      :classified_wizard_class_name, :skip_deferred
    ]
  end

  include EffectiveGem

  def self.ClassifiedWizard
    classified_wizard_class_name&.constantize || Effective::ClassifiedWizard
  end

  def self.mailer_class
    mailer&.constantize || Effective::ClassifiedsMailer
  end

end
