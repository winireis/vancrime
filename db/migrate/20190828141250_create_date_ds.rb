class CreateDateDs < ActiveRecord::Migration[6.0]
  def change
    create_table :date_ds do |t|
      t.string :fulldate
      t.integer :year
      t.integer :month
      t.integer :weekday
      t.integer :day
      t.timestamps
    end
    add_index :date_ds, :fulldate, unique: true
    add_index :date_ds, :year
    add_index :date_ds, :month
    add_index :date_ds, :weekday
    add_index :date_ds, :day
  end
end
