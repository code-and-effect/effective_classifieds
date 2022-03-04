module Effective
  class ClassifiedsMailer < EffectiveClassifieds.parent_mailer_class

    include EffectiveMailer

    def classified_submitted(resource, opts = {})
      raise('expected an Effective::Classified') unless resource.kind_of?(Effective::Classified)

      @classified = resource
      subject = subject_for(:classified_submitted, 'Classified Submitted', resource, opts)
      headers = headers_for(resource, opts)

      mail(to: mailer_admin, subject: subject, **headers)
    end

  end
end
