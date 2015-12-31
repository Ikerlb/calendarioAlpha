class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.integer :notification_time
      t.string :name

      t.timestamps null: false
    end
  end
end
