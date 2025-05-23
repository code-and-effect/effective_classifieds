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
      order :start_on

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

      col :website, visible: false
      col :contact_name, visible: false
      col :email, visible: false
      col :phone, visible: false

      col :status
      col :archived

      col :status
      col :tracks_count, label: 'Views'

      col :purchased_order, visible: false

      col :qb_item_name, label: qb_item_name_label, search: Effective::ItemName.sorted.map(&:to_s), 
        visible: EffectiveOrders.use_item_names? && EffectiveClassifieds.default_qb_item_name.blank?

      actions_col do |classified|
        dropdown_link_to("View #{classified_label}", effective_classifieds.classified_path(classified), target: '_blank')
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
