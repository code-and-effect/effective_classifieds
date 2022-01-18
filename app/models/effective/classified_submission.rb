module Effective
  class ClassifiedSubmission < ActiveRecord::Base
    self.table_name = EffectiveClassifieds.classified_submissions_table_name.to_s

    effective_classifieds_classified_submission
  end
end
