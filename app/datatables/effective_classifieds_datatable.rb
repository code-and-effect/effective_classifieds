# Dashboard Classifieds
class EffectiveClassifiedsDatatable < Effective::Datatable
  datatable do
    order :title

    col :id, visible: false

    col :title

    actions_col
  end

  collection do
    EffectiveClassifieds.Classified.classifieds(user: current_user)
  end

end
