# Dashboard Classifieds
class EffectiveClassifiedsDatatable < Effective::Datatable
  datatable do
    length :all
    order :end_on

    col :start_on, as: :date, label: 'Published'
    col :end_on, as: :date, label: 'Closing'

    col :title do |classified|
      link_to classified, effective_classifieds.classified_path(classified)
    end

    col :organization
    col :location

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
