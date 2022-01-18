module EffectiveClassifiedsHelper

  def edit_effective_classified_submissions_wizard?
    params[:controller] == 'effective/classified_submissions' && defined?(resource) && resource.draft?
  end

end
