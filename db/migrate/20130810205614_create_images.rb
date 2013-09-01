class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :title
      t.string :name
      t.string :lastname
      t.string :email
      t.string :url
      t.boolean :approved

      t.timestamps
    end
  end
end
