class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.references :user, foreign_key: true
      t.string :title, default: ""
      t.decimal :price, default: 0.0
      t.boolean :published, default: false

      t.timestamps
    end
  end
end
