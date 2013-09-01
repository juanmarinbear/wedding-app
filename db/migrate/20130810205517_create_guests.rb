class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.string :name
      t.string :lastname
      t.string :email
      t.string :mobile
      t.string :facebook
      t.string :twitter
      t.string :instagram
      t.string :dish
      t.integer :companion_id

      t.timestamps
    end
  end
end
