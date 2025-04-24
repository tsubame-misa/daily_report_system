class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.string :title, null: false
      t.text :contents, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
