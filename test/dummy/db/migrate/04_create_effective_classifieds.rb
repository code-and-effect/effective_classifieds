class CreateEffectiveClassifieds < ActiveRecord::Migration[6.1]
  def change
    create_table :classifieds do |t|
      t.integer :classified_submission_id
      t.string :classified_submission_type

      t.integer :owner_id
      t.string :owner_type

      t.string :title
      t.string :category

      t.string :organization
      t.string :location

      t.string :website
      t.string :email
      t.string :phone

      t.datetime :start_on
      t.datetime :end_on

      t.string :slug

      t.string :status
      t.text :status_steps

      t.integer :roles_mask
      t.boolean :authenticate_user, default: false

      t.boolean :archived, default: false

      t.timestamps
    end

    add_index :classifieds, [:owner_id, :owner_type]
    add_index :classifieds, :start_on
    add_index :classifieds, :end_on
    add_index :classifieds, :slug

    create_table :classified_submissions do |t|
      t.string :token

      t.integer :owner_id
      t.string :owner_type

      # Acts as Statused
      t.string :status
      t.text :status_steps

      # Acts as Wizard
      t.text :wizard_steps

      # Dates
      t.datetime :submitted_at

      t.datetime :updated_at
      t.datetime :created_at
    end

    add_index :classified_submissions, [:owner_id, :owner_type]
    add_index :classified_submissions, :status
    add_index :classified_submissions, :token
  end
end
