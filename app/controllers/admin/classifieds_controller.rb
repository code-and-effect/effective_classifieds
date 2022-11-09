module Admin
  class ClassifiedsController < ApplicationController
    before_action(:authenticate_user!) if defined?(Devise)
    before_action { EffectiveResources.authorize!(self, :admin, :effective_classifieds) }

    include Effective::CrudController

    page_title(only: :index) { EffectiveClassifieds.classifieds_label }
    page_title(only: :new) { "New #{EffectiveClassifieds.classifieds_label} Posting" }

    submit :save, 'Save'
    submit :save, 'Save and View', redirect: -> { effective_classifieds.classified_path(resource) }
    submit :approve, 'Approve'

    private

    def permitted_params
      model = (params.key?(:effective_classified) ? :effective_classified : :classified)
      params.require(model).permit!
    end

  end
end
