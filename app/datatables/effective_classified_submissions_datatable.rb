# Dashboard Classified Submissions
class EffectiveClassifiedSubmissionsDatatable < Effective::Datatable
  datatable do
    order :created_at

    col :token, visible: false
    col :created_at, visible: false

    col :submitted_at do |submission|
      submission.submitted_at&.strftime('%F') || 'Incomplete'
    end

    col :classified, search: :string do |submission|
      submission.classified.to_s
    end

    col :owner, visible: false, search: :string
    col :status, visible: false

    actions_col(actions: []) do |submission|
      if submission.draft?
        dropdown_link_to('Continue', effective_classifieds.classified_submission_build_path(submission, submission.next_step), 'data-turbolinks' => false)
        dropdown_link_to('Delete', effective_classifieds.classified_submission_path(submission), 'data-confirm': "Really delete #{submission}?", 'data-method': :delete)
      else
        dropdown_link_to('Show', effective_classifieds.classified_submission_path(submission))
      end
    end
  end

  collection do
    EffectiveEvents.ClassifiedSubmission.deep.where(owner: current_user)
  end

end
