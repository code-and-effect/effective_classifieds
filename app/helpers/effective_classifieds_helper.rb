module EffectiveClassifiedsHelper

  # Job Board or Classifieds
  def classifieds_name_label
    et('effective_classifieds.name')
  end

  # Job Board Posting or Classified Posting
  def classified_label
    et(Effective::Classified)
  end

  # Job Board Postings or Classified Postings
  def classifieds_label
    ets(Effective::Classified)
  end
end
