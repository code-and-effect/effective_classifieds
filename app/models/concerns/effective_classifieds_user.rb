# EffectiveClassifiedsUser
#
# Mark your user model with effective_classifieds_user to get all the includes

module EffectiveClassifiedsUser
  extend ActiveSupport::Concern

  module Base
    def effective_classifieds_user
      include ::EffectiveClassifiedsUser
    end
  end

  module ClassMethods
    def effective_classifieds_user?; true; end
  end

  included do
    has_many :representatives, -> { Effective::Representative.sorted },
      class_name: 'Effective::Representative', inverse_of: :user, dependent: :delete_all

    accepts_nested_attributes_for :representatives, allow_destroy: true
  end

  # Instance Methods

  def representative(classified:)
    representatives.find { |rep| rep.classified_id == classified.id }
  end

  # Find or build
  def build_representative(classified:)
    representative(classified: classified) || representatives.build(classified: classified)
  end

  def classifieds
    representatives.reject(&:marked_for_destruction?).map(&:classified)
  end

end
