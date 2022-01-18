require 'effective_resources'
require 'effective_datatables'
require 'effective_classifieds/engine'
require 'effective_classifieds/version'

module EffectiveClassifieds

  def self.config_keys
    [
      :classifieds_table_name,
      :layout, :classified_class_name
    ]
  end

  include EffectiveGem

  def self.Classified
    classified_class_name&.constantize || Effective::Classified
  end

end
