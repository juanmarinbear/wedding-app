class SetDefaultApprovedValueImages < ActiveRecord::Migration
  def change
    change_column :images, :approved, :boolean, default: false
  end
end
