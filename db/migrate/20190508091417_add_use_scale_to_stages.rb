class AddUseScaleToStages < ActiveRecord::Migration[5.1]
  def change
    add_column :stages, :with_scale, :boolean, null: false, default: true
    add_column :stages, :with_truncation, :boolean, null: false, default: true
  end
end
