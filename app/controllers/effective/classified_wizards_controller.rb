module Effective
  class ClassifiedWizardsController < ApplicationController
    before_action(:authenticate_user!) if defined?(Devise)

    include Effective::WizardController

    resource_scope -> { EffectiveClassifieds.ClassifiedWizard.deep.where(owner: current_user) }

  end
end
