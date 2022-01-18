module Admin
  class EffectiveClassifiedsDatatable < Effective::Datatable
    datatable do

      col :updated_at, visible: false
      col :created_at, visible: false

      col :id, visible: false

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

      col :start_at
      col :end_at

      col :status, search: ['submitted', 'approved']

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
