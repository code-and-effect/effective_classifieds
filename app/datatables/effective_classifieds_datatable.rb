# Dashboard Classifieds
class EffectiveClassifiedsDatatable < Effective::Datatable
  datatable do
    order :title

    col :id, visible: false

    col :title
    col :representatives

    actions_col
  end

  collection do
    EffectiveClassifieds.Classified.deep.where(id: current_user.classifieds)
  end

end
