# Dashboard Classifieds
class EffectiveClassifiedsDatatable < Effective::Datatable
  datatable do
    length :all
    order :start_on

    col :start_on, as: :date, label: 'Posted'

    col :title do |classified|
      link_to classified, effective_classifieds.classified_path(classified)
    end

    col :end_on, as: :date, label: 'Expires', visible: false

    col :organization, visible: false
    col :location, visible: false

    col :body, visible: false
    col :website, visible: false
    col :email, visible: false
    col :phone, visible: false

    # actions_col(edit: false)
  end

  collection do
    Effective::Classified.classifieds(user: current_user)
  end

end
