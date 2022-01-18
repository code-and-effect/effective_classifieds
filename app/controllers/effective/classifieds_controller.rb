module Effective
  class ClassifiedsController < ApplicationController
    before_action(:authenticate_user!) if defined?(Devise)

    include Effective::CrudController

    private

    def permitted_params
      params.require(:classified).permit!
    end

  end
end
