# Dashboard Classifieds
class EffectiveClassifiedsDatatable < Effective::Datatable
  datatable do
    order :start_on

    col :start_on, as: :date, label: 'Starts'
    col :end_on, as: :date, label: 'Ends'

    col :title
    col :organization
    col :location

    col :body, visible: false
    col :website, visible: false
    col :email, visible: false
    col :phone, visible: false

    actions_col(edit: false)
  end

  collection do
    Effective::Classified.classifieds(user: current_user)
  end

end
