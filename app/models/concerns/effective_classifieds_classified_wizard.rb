# frozen_string_literal: true

# EffectiveClassifiedsClassifiedWizard
#
# Mark your owner model with effective_classifieds_classified_wizard to get all the includes

module EffectiveClassifiedsClassifiedWizard
  extend ActiveSupport::Concern

  module Base
    def effective_classifieds_classified_wizard
      include ::EffectiveClassifiedsClassifiedWizard
    end
  end

  module ClassMethods
    def effective_classifieds_classified_wizard?; true; end
  end

  included do
    acts_as_tokened
    acts_as_purchasable_parent

    acts_as_statused(
      :draft,      # Just Started
      :submitted   # All done
    )

    acts_as_wizard(
      start: 'Start',
      classified: 'Posting',
      summary: 'Review',
      billing: 'Billing Address',
      checkout: 'Checkout',
      submitted: 'Submitted'
    )

    acts_as_purchasable_wizard

    log_changes(except: :wizard_steps) if respond_to?(:log_changes)

    # Application Namespace
    belongs_to :owner, polymorphic: true
    accepts_nested_attributes_for :owner

    # Effective Namespace
    has_many :classifieds, class_name: 'Effective::Classified', inverse_of: :classified_wizard, dependent: :destroy
    accepts_nested_attributes_for :classifieds, reject_if: :all_blank, allow_destroy: true

    effective_resource do
      # Acts as Statused
      status                 :string, permitted: false
      status_steps           :text, permitted: false

      # Dates
      submitted_at           :datetime

      # Pricing
      price_category          :string

      # Acts as Wizard
      wizard_steps           :text, permitted: false

      timestamps
    end

    scope :deep, -> { includes(:classifieds) }
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

    # All Fees and Orders
    def submit_fees
      classifieds
    end

    def after_submit_purchased!
      # Nothing to do
    end

    # Overrides the acts_as_purchasable_wizard submit!
    def submit!
      raise('already submitted') if was_submitted?

      if checkout_required?
        raise('expected a purchased order') unless submit_order&.purchased?
        wizard_steps[:checkout] ||= Time.zone.now
      end

      wizard_steps[:submitted] = Time.zone.now
      classified.submit! unless classified.was_submitted?

      submitted!
    end
  end

  # Instance Methods
  def to_s
    model_name.human
  end

  def in_progress?
    draft?
  end

  def done?
    submitted?
  end

  def checkout_required?
    required_steps.include?(:billing) && required_steps.include?(:checkout)
  end

  def no_checkout_required?
    required_steps.exclude?(:billing) && required_steps.exclude?(:checkout)
  end

  def classified
    classifieds.first
  end

  def build_classified
    classifieds.build(owner: owner)
  end

  def assign_pricing
    raise('to be implemented by including class')
    # classified.assign_attributes(price: price, qb_item_name: qb_item_name, tax_exempt: tax_exempt)
  end

  # After the configure Classified step
  def classified!
    assign_pricing() if classified.present?
    raise('expected classified to have a price') if classified.price.blank?

    save!
  end

  # This is the review/summary step. Last one if we're not doing checkout
  def summary!
    return submit! if no_checkout_required?
    save!
  end

end
