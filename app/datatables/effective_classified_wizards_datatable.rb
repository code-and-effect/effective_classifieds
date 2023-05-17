# Dashboard Classified Submissions
class EffectiveClassifiedWizardsDatatable < Effective::Datatable
  datatable do
    order :created_at

    col :token, visible: false
    col :created_at, visible: false

    col :submitted_at, label: 'Submitted' do |wizard|
      wizard.submitted_at&.strftime('%F') || 'Incomplete'
    end

    col :classifieds, search: :string, label: 'Title'

    col :owner, visible: false, search: :string

    col :status, visible: false do |wizard|
      wizard.classified&.status || wizard.status
    end

    actions_col(actions: []) do |wizard|
      if wizard.draft?
        dropdown_link_to('Continue', effective_classifieds.classified_wizard_build_path(wizard, wizard.next_step), 'data-turbolinks' => false)
      elsif wizard.classified.present?
        dropdown_link_to('Show', effective_classifieds.classified_path(wizard.classified))
        dropdown_link_to('Edit', effective_classifieds.edit_classified_path(wizard.classified))
        dropdown_link_to('Show Wizard', effective_classifieds.classified_wizard_path(wizard), 'data-turbolinks' => false)
      end

      if EffectiveResources.authorized?(self, :destroy, wizard)
        dropdown_link_to('Delete', effective_classifieds.classified_wizard_path(wizard), 'data-confirm': "Really delete #{wizard}?", 'data-method': :delete)
      end

    end
  end

  collection do
    EffectiveClassifieds.ClassifiedWizard.deep.where(owner: current_user)
  end

end
