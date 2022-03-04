module Effective
  class ClassifiedsMailer < EffectiveClassifieds.parent_mailer_class

    default from: -> { EffectiveClassifieds.mailer_sender }
    layout -> { EffectiveClassifieds.mailer_layout }

    def classified_submitted(resource, opts = {})
      raise('expected an Effective::Classified') unless resource.kind_of?(Effective::Classified)

      @classified = resource

      mail(to: EffectiveClassifieds.mailer_admin, **headers_for(resource, opts))
    end

    protected

    def headers_for(resource, opts = {})
      resource.respond_to?(:log_changes_datatable) ? opts.merge(log: resource) : opts
    end

  end
end
