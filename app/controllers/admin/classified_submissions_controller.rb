module Admin
  class ClassifiedSubmissionsController < ApplicationController
    before_action(:authenticate_user!) if defined?(Devise)
    before_action { EffectiveResources.authorize!(self, :admin, :effective_classifieds) }

    include Effective::CrudController

    resource_scope -> { EffectiveEvents.ClassifiedSubmission.deep.all }
    datatable -> { Admin::EffectiveClassifiedSubmissionsDatatable.new }

    private

    def permitted_params
      model = (params.key?(:effective_classified_submission) ? :effective_classified_submission : :classified_submission)
      params.require(model).permit!
    end

  end
end
