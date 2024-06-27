module Effective
  class ClassifiedsController < ApplicationController
    include Effective::CrudController

    def index
      EffectiveResources.authorize!(self, :index, ::Effective::Classified)

      @page_title ||= view_context.classifieds_name_label

      @classifieds = ::Effective::Classified.classifieds(user: current_user).sorted
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
          ('You are viewing a hidden posting.' unless @classified.published?),
          ("<a href='#{effective_classifieds.edit_admin_classified_path(@classified)}' class='alert-link'>Click here to edit settings</a>.")
        ].compact.join(' ')
      end

      @page_title ||= @classified.to_s

      respond_to do |format|
        format.html { }

        format.json {
          url = effective_classifieds.classified_url(@classified, format: :json)
          render(json: @classified.for_json.merge(url: url).to_json)
        }
      end
    end

    private

    def permitted_params
      params.require(:effective_classified).except(:status, :status_steps).permit!
    end

  end
end
