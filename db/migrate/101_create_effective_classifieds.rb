class CreateEffectiveClassifieds < ActiveRecord::Migration[6.0]
  def change
    create_table :classifieds do |t|
      t.integer :classified_wizard_id
      t.string :classified_wizard_type

      t.integer :owner_id
      t.string :owner_type

      t.string :title
      t.string :category

      t.string :organization
      t.string :location

      t.string :website
      t.string :contact_name
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

      # Acts as purchasable
      t.integer :purchased_order_id
      t.integer :price
      t.boolean :tax_exempt, default: false
      t.string :qb_item_name

      # Acts as trackable
      t.integer :tracks_count, default: 0

      t.timestamps
    end

    add_index :classifieds, [:owner_id, :owner_type]
    add_index :classifieds, :slug
    add_index :classifieds, :classified_wizard_id, if_not_exists: true
    add_index :classifieds, :archived, if_not_exists: true

    create_table :classified_wizards do |t|
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

      # Pricing
      t.integer :user_id
      t.string :user_type
      t.string :price_category

      t.datetime :updated_at
      t.datetime :created_at
    end

    add_index :classified_wizards, [:owner_id, :owner_type]
    add_index :classified_wizards, :token
  end
end
