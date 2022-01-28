module EffectiveClassifieds
  class Engine < ::Rails::Engine
    engine_name 'effective_classifieds'

    # Set up our default configuration options.
    initializer 'effective_classifieds.defaults', before: :load_config_initializers do |app|
      eval File.read("#{config.root}/config/effective_classifieds.rb")
    end

    # Include acts_as_addressable concern and allow any ActiveRecord object to call it
    initializer 'effective_classifieds.active_record' do |app|
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.extend(EffectiveClassifiedsClassifiedWizard::Base)
      end
    end

  end
end
