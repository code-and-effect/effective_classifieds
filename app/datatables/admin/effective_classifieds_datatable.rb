module Admin
  class EffectiveClassifiedsDatatable < Effective::Datatable
    filters do
      scope :all

      unless EffectiveClassifieds.auto_approve
        scope :submitted
        scope :approved
      end

      scope :published
    end

    datatable do

      col :updated_at, visible: false
      col :created_at, visible: false

      col :id, visible: false

      col :classified_submission, visible: false, search: :string

      col :start_on, as: :date
      col :end_on, as: :date

      if categories.present?
        col :category, search: categories
      end

      col :title
      col :body
      col :slug, visible: false

      col :organization
      col :location

      col :website
      col :email
      col :phone

      col :archived

      unless EffectiveClassifieds.auto_approve
        col :status, search: ['submitted', 'approved']
      end

      actions_col do |classified|
        dropdown_link_to('View Classified', effective_classifieds.classified_path(classified), target: '_blank')
      end
    end

    collection do
      Effective::Classified.all.where.not(status: :draft)
    end

    def categories
      EffectiveClassifieds.categories
    end

  end
end
