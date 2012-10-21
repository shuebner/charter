class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
      t.string :name, null: false
      t.date :begin_date, null: false
      t.date :end_date, null: false

      t.timestamps
    end
  end
end
