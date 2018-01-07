class AddUnitToCategories < ActiveRecord::Migration[5.0]
  def change
  	add_column :categories, :unit, :string
  end
end
