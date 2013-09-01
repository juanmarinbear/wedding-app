class DeleteColumnsFromImages < ActiveRecord::Migration
  def change
    remove_column :images, :title
    remove_column :images, :name
    remove_column :images, :lastname
    remove_column :images, :email
  end
end
