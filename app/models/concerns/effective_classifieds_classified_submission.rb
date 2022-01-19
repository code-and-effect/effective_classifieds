# frozen_string_literal: true

# EffectiveClassifiedsClassifiedSubmission
#
# Mark your owner model with effective_classifieds_classified_submission to get all the includes

module EffectiveClassifiedsClassifiedSubmission
  extend ActiveSupport::Concern

  module Base
    def effective_classifieds_classified_submission
      include ::EffectiveClassifiedsClassifiedSubmission
    end
  end

  module ClassMethods
    def effective_classifieds_classified_submission?; true; end

    def all_wizard_steps
      const_get(:WIZARD_STEPS).keys
    end

    def required_wizard_steps
      [:start, :summary, :submitted]
    end
  end

  included do
    acts_as_tokened

    acts_as_statused(
      :draft,      # Just Started
      :submitted   # All done
    )

    acts_as_wizard(
      start: 'Start',
      classified: 'Classified',
      summary: 'Review',
      submitted: 'Submitted'
    )

    log_changes(except: :wizard_steps) if respond_to?(:log_changes)

    # Application Namespace
    belongs_to :owner, polymorphic: true
    accepts_nested_attributes_for :owner

    # Effective Namespace
    has_one :classified, class_name: 'Effective::Classified', inverse_of: :classified_submission, dependent: :destroy
    accepts_nested_attributes_for :classified, reject_if: :all_blank, allow_destroy: true

    effective_resource do
      # Acts as Statused
      status                 :string, permitted: false
      status_steps           :text, permitted: false

      # Dates
      submitted_at           :datetime

      # Acts as Wizard
      wizard_steps           :text, permitted: false

      timestamps
    end

    scope :deep, -> { includes(:classified) }
    scope :sorted, -> { order(:id) }

    scope :in_progress, -> { where.not(status: [:submitted]) }
    scope :done, -> { where(status: [:submitted]) }

    scope :for, -> (user) { where(owner: user) }

    # All Steps validations
    validates :owner, presence: true

    # Classified Step
    with_options(if: -> { current_step == :classified }) do
      validates :classified, presence: true
    end
  end

  # Instance Methods
  def to_s
    'classified submission'
  end

  def in_progress?
    draft?
  end

  def done?
    submitted?
  end

  # Called on the Review / Summary Step
  # But we actually want to submit it
  def summary!
    submit!
  end

  def submit!
    raise('already submitted') if was_submitted?

    wizard_steps[:submitted] = Time.zone.now

    classified.submitted! unless classified.was_submitted?
    submitted!
  end

end
