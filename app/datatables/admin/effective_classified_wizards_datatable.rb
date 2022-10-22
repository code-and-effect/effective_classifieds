class Admin::EffectiveClassifiedWizardsDatatable < Effective::Datatable
  datatable do
    order :created_at

    col :token, visible: false

    col :created_at, label: 'Created', visible: false
    col :updated_at, label: 'Updated', visible: false

    col :submitted_at, label: 'Submitted', visible: false, as: :date

    col :classified, search: :string
    col :owner

    col :orders

    actions_col
  end

  collection do
    EffectiveClassifieds.ClassifiedWizard.all.deep.done.joins(:classified)
  end

end
