# frozen_string_literal: true

module Effective
  class Classified < ActiveRecord::Base
    self.table_name = EffectiveClassifieds.classifieds_table_name.to_s

    attr_accessor :current_user

    acts_as_slugged
    log_changes if respond_to?(:log_changes)
    acts_as_role_restricted if respond_to?(:acts_as_role_restricted)

    # This will be the owner of the classified ad submission
    # Or the admin user that created it
    belongs_to :owner, polymorphic: true

    # When submitted through the wizard
    belongs_to :classified_wizard, polymorphic: true, optional: true

    has_rich_text :body

    acts_as_statused(
      :draft,       # Initial state
      :submitted,   # Once submitted by the classified ad submission.
      :approved     # Exit state. Classified was approved.
    )

    effective_resource do
      title              :string
      category           :string

      organization       :string    # Or seller
      location           :string

      website            :string
      email              :string
      phone              :string

      # Logic
      start_on           :date
      end_on             :date

      # Acts as Slugged
      slug               :string

      # Acts as Statused
      status                 :string, permitted: false
      status_steps           :text, permitted: false

      # Access
      roles_mask         :integer
      authenticate_user  :boolean

      archived           :boolean

      timestamps
    end

    scope :sorted, -> { order(:id) }
    scope :deep, -> { with_rich_text_body }

    scope :upcoming, -> { where(arel_table[:end_on].gt(Time.zone.now)) }
    scope :past, -> { where(arel_table[:end_on].lteq(Time.zone.now)) }

    scope :unarchived, -> { where(archived: false) }
    scope :archived, -> { where(archived: true) }

    scope :published, -> {
      approved
      .unarchived
      .where(arel_table[:start_on].lteq(Time.zone.now))
      .where(arel_table[:end_on].gt(Time.zone.now))
    }

    scope :paginate, -> (page: nil, per_page: nil) {
      page = (page || 1).to_i
      offset = [(page - 1), 0].max * (per_page || EffectiveClassifieds.per_page)

      limit(per_page).offset(offset)
    }

    scope :classifieds, -> (user: nil, unpublished: false) {
      scope = all.deep.sorted

      if defined?(EffectiveRoles) && EffectiveClassifieds.use_effective_roles
        scope = scope.for_role(user&.roles)
      end

      if user.blank?
        scope = scope.where(authenticate_user: false)
      end

      unless unpublished
        scope = scope.published
      end

      scope
    }

    before_validation(if: -> { current_user.present? }) do
      self.owner ||= current_user
    end

    # Automatically approve submissions created by admins outside the submissions wizard
    before_validation(if: -> { new_record? && classified_wizard.blank? }) do
      assign_attributes(status: :approved)
    end

    validates :title, presence: true, length: { maximum: 200 }
    validates :category, presence: true
    validates :body, presence: true

    validates :start_on, presence: true
    validates :end_on, presence: true
    validates :location, presence: true

    validates :organization, presence: true
    validates :email, presence: true
    validates :phone, presence: true

    validate(if: -> { start_on.present? && end_on.present? }) do
      self.errors.add(:end_on, 'must be after start date') if end_on < start_on
    end

    validate(if: -> { start_on.present? && end_on.present? && EffectiveClassifieds.max_duration.present? }) do
      if (end_on - start_on) > EffectiveClassifieds.max_duration
        distance = ApplicationController.helpers.distance_of_time_in_words(end_on + EffectiveClassifieds.max_duration, end_on).gsub('about', '').strip
        self.errors.add(:end_on, "must be within #{distance} of start date")
      end
    end

    validate(if: -> { category.present? }) do
      self.errors.add(:category, 'is invalid') unless Array(EffectiveClassifieds.categories).include?(category)
    end

    def to_s
      title.presence || 'New Classified'
    end

    def published?
      return false unless approved?
      return false if archived?
      return false if start_on.blank? || (Time.zone.now.to_date < start_on)
      return false if end_on.present? && (Time.zone.now.to_date >= end_on)
      true
    end

    def submit!
      submitted!
      approve! if EffectiveClassifieds.auto_approve

      after_commit do
        EffectiveClassifieds.send_email(:classified_submitted, self)
      end

      true
    end

    def approve!
      approved!
    end

  end
end
