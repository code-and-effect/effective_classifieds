module EffectiveClassifiedsHelper

  # Job Board or Classifieds
  def classifieds_name_label
    et('effective_classifieds.name')
  end

  # Job or Classified
  def classified_label
    et(Effective::Classified)
  end

  # Jobs or Classifieds
  def classifieds_label
    ets(Effective::Classified)
  end
end
