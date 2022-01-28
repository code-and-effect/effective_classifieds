require 'effective_resources'
require 'effective_datatables'
require 'effective_classifieds/engine'
require 'effective_classifieds/version'

module EffectiveClassifieds

  def self.config_keys
    [
      :classifieds_table_name, :classified_wizards_table_name,
      :layout, :categories, :per_page, :use_effective_roles, :max_duration, :auto_approve,
      :classified_wizard_class_name,
      :mailer, :parent_mailer, :deliver_method, :mailer_layout, :mailer_sender, :mailer_admin
    ]
  end

  include EffectiveGem

  def self.ClassifiedWizard
    classified_wizard_class_name&.constantize || Effective::ClassifiedWizard
  end

  def self.mailer_class
    mailer&.constantize || Effective::ClassifiedsMailer
  end

  def self.parent_mailer_class
    return parent_mailer.constantize if parent_mailer.present?
    ActionMailer::Base
  end

  def self.send_email(email, *args)
    raise('expected args to be an Array') unless args.kind_of?(Array)

    if defined?(Tenant)
      tenant = Tenant.current || raise('expected a current tenant')
      args.last.kind_of?(Hash) ? args.last.merge!(tenant: tenant) : args << { tenant: tenant }
    end

    deliver_method = EffectiveClassifieds.deliver_method || EffectiveResources.deliver_method

    EffectiveClassifieds.mailer_class.send(email, *args).send(deliver_method)
  end

end
