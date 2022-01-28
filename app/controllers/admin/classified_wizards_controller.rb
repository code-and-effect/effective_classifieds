module Admin
  class ClassifiedWizardsController < ApplicationController
    before_action(:authenticate_user!) if defined?(Devise)
    before_action { EffectiveResources.authorize!(self, :admin, :effective_classifieds) }

    include Effective::CrudController

    resource_scope -> { EffectiveEvents.ClassifiedWizard.deep.all }
    datatable -> { Admin::EffectiveClassifiedWizardsDatatable.new }

    private

    def permitted_params
      model = (params.key?(:effective_classified_wizard) ? :effective_classified_wizard : :classified_wizard)
      params.require(model).permit!
    end

  end
end
