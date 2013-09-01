class AddUploaderIdToImages < ActiveRecord::Migration
  def change
    add_column :images, :uploader_id, :integer
  end
end
