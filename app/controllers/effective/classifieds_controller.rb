module Effective
  class ClassifiedsController < ApplicationController
    include Effective::CrudController

    def index
      EffectiveResources.authorize!(self, :index, Effective::Classified)
      @classifieds = Effective::Classified.classifieds(user: current_user)
      @page_title = "Classifieds"
    end

    def show
      @classified = resource_scope.find(params[:id])

      if @classified.respond_to?(:roles_permit?)
        raise Effective::AccessDenied.new('Access Denied', :show, @classified) unless @classified.roles_permit?(current_user)
      end

      EffectiveResources.authorize!(self, :show, @classified)

      if EffectiveResources.authorized?(self, :admin, :effective_classifieds)
        flash.now[:warning] = [
          'Hi Admin!',
          ('You are viewing a hidden classified.' unless @classified.published?),
          'Click here to',
          ("<a href='#{effective_classifieds.edit_admin_classified_path(@classified)}' class='alert-link'>edit classified settings</a>.")
        ].compact.join(' ')
      end

      @page_title ||= @classified.to_s
    end

    private

    def permitted_params
      params.require(:effective_classified).permit!.except(:status, :status_steps)
    end

  end
end
