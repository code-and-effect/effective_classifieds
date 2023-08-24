module Effective
  class ClassifiedWizard < ActiveRecord::Base
    self.table_name = (EffectiveClassifieds.classified_wizards_table_name || :classified_wizards).to_s

    effective_classifieds_classified_wizard
  end
end
