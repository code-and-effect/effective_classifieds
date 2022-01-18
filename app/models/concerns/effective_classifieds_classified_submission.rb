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
      [:start, :classified, :review, :submitted]
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
      submit: 'Review',
      submitted: 'Submitted'
    )

    log_changes(except: :wizard_steps) if respond_to?(:log_changes)

    # Application Namespace
    belongs_to :owner, polymorphic: true
    accepts_nested_attributes_for :owner

    # Effective Namespace
    belongs_to :classified, class_name: 'Effective::Classified', optional: true
    accepts_nested_attributes_for :classified

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

    scope :deep, -> { includes(:owner, :classified) }
    scope :sorted, -> { order(:id) }

    scope :in_progress, -> { where.not(status: [:submitted]) }
    scope :done, -> { where(status: [:submitted]) }

    scope :for, -> (user) { where(owner: user) }

    # All Steps validations
    validates :owner, presence: true

    # Classified Step
    validate(if: -> { current_step == :classified }) do
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

end
