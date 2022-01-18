# Dashboard Classifieds
class EffectiveClassifiedsDatatable < Effective::Datatable
  datatable do
    order :start_on

    col :start_on, as: :date, label: 'Starts'
    col :end_on, as: :date, label: 'Ends'

    col :title
    col :organization
    col :location

    actions_col
  end

  collection do
    Effective::Classified.classifieds(user: current_user)
  end

end
