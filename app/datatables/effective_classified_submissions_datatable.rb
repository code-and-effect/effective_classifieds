# Dashboard Classified Submissions
class EffectiveClassifiedSubmissionsDatatable < Effective::Datatable
  datatable do
    order :created_at

    col :token, visible: false
    col :created_at, visible: false

    col :submitted_at do |submission|
      submission.submitted_at&.strftime('%F') || 'Incomplete'
    end

    col :classified, search: :string

    col :owner, visible: false, search: :string

    col :status do |submission|
      submission.classified&.status || submission.status
    end

    actions_col(actions: []) do |submission|
      if submission.draft?
        dropdown_link_to('Continue', effective_classifieds.classified_submission_build_path(submission, submission.next_step), 'data-turbolinks' => false)
        dropdown_link_to('Delete', effective_classifieds.classified_submission_path(submission), 'data-confirm': "Really delete #{submission}?", 'data-method': :delete)
      else
        dropdown_link_to('Show', effective_classifieds.classified_submission_path(submission))
      end

      if submission.was_submitted? && (classified = submission.classified).present?
        dropdown_link_to('Edit Classified', effective_classifieds.edit_classified_path(classified))
        dropdown_link_to('Delete Classified', effective_classifieds.classified_path(classified), 'data-confirm': "Really delete #{classified}?", 'data-method': :delete)
      end
    end
  end

  collection do
    EffectiveClassifieds.ClassifiedSubmission.deep.where(owner: current_user).left_joins(:classified)
  end

end
