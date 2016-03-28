class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references :user, index: true, foreign_key: true
      t.string :google_id
      t.string :comment
      t.string :latitude
      t.string :longitude
      t.string :address
      t.string :full_address

      t.timestamps null: false
    end
  end
end
