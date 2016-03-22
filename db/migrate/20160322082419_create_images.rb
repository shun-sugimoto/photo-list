class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :image_path
      t.string :comment

      t.timestamps null: false
    end
  end
end
