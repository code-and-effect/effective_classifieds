module Effective
  class ClassifiedsController < ApplicationController
    include Effective::CrudController

    resource_scope -> {
      unpublished = EffectiveResources.authorized?(self, :admin, :effective_classifieds)
      Effective::Classified.classifieds(user: current_user, unpublished: unpublished)
    }

    def index
      @classifieds ||= resource_scope.published

      @classifieds = @classifieds.paginate(page: params[:page])

      # if params[:search].present?
      #   search = params[:search].permit(EffectiveClassifieds.permitted_params).delete_if { |k, v| v.blank? }
      #   @classifieds = @classifieds.where(search) if search.present?
      # end

      EffectiveResources.authorize!(self, :index, Effective::Classified)

      @page_title ||= ['Classifieds', (" - Page #{params[:page]}" if params[:page])].compact.join
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

  end
end
