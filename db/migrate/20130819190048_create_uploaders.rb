class CreateUploaders < ActiveRecord::Migration
  def change
    create_table :uploaders do |t|
      t.string :name
      t.string :lastname
      t.string :email

      t.timestamps
    end
  end
end
