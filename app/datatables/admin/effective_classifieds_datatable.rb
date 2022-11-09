module Admin
  class EffectiveClassifiedsDatatable < Effective::Datatable
    filters do
      scope :all

      unless EffectiveClassifieds.auto_approve
        scope :submitted
        scope :approved
      end

      scope :draft
      scope :published
    end

    datatable do

      col :updated_at, visible: false
      col :created_at, visible: false

      col :id, visible: false

      col :classified_wizard, visible: false, search: :string
      col :owner, visible: false, label: 'Submitted by'

      col :start_on, as: :date
      col :end_on, as: :date

      if categories.present?
        col :category, search: categories
      end

      col :title
      col :body, visible: false
      col :slug, visible: false

      col :organization
      col :location

      col :website
      col :email
      col :phone

      col :status
      col :archived

      col :status

      col :purchased_order, visible: false

      actions_col do |classified|
        dropdown_link_to('View Classified', effective_classifieds.classified_path(classified), target: '_blank')
      end
    end

    collection do
      Effective::Classified.all
    end

    def categories
      EffectiveClassifieds.categories
    end

  end
end
