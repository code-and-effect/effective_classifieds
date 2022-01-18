module Effective
  class Classified < ActiveRecord::Base
    self.table_name = EffectiveClassifieds.classifieds_table_name.to_s

    effective_classifieds_classified

  end
end
