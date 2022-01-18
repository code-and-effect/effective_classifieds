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

      col :representatives_count
      col :representatives

      actions_col
    end

    collection do
      EffectiveClassifieds.Classified.deep.all
    end

    def categories
      EffectiveClassifieds.Classified.categories
    end

  end
end
