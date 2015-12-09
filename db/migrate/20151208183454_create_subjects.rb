class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :group_number
      t.text :google_calendar_id
      t.string :name
      t.text :body

      t.timestamps null: false
    end
  end
end
