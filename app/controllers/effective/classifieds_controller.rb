module Effective
  class ClassifiedsController < ApplicationController
    include Effective::CrudController

    page_title(only: :index) { EffectiveClassifieds.classifieds_label }

    def show
      @classified = resource_scope.find(params[:id])

      if @classified.respond_to?(:roles_permit?)
        raise Effective::AccessDenied.new('Access Denied', :show, @classified) unless @classified.roles_permit?(current_user)
      end

      EffectiveResources.authorize!(self, :show, @classified)

      if EffectiveResources.authorized?(self, :admin, :effective_classifieds)
        flash.now[:warning] = [
          'Hi Admin!',
          ('You are viewing a hidden posting.' unless @classified.published?),
          ("<a href='#{effective_classifieds.edit_admin_classified_path(@classified)}' class='alert-link'>Click here to edit settings</a>.")
        ].compact.join(' ')
      end

      @page_title ||= @classified.to_s
    end

    private

    def permitted_params
      params.require(:effective_classified).except(:status, :status_steps).permit!
    end

  end
end
