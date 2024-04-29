class ClassifiedWizard < ApplicationRecord
  # To define custom wizard steps, declare acts_as_wizard() first
  # To define custom status steps, declare acts_as_statused() first

  effective_classifieds_classified_wizard

  def assign_pricing
    if owner.is?(:member)
      classified.assign_attributes(price: 0) # Free for members
    else
      classified.assign_attributes(price: 100_00, qb_item_name: classified.category, tax_exempt: false)
    end
  end
end
