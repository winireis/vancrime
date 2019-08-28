class CreateTimeDs < ActiveRecord::Migration[6.0]
  def change
    create_table :time_ds do |t|
      t.string :fulltime
      t.integer :hour
      t.integer :minute
      t.timestamps
    end
    add_index :time_ds, :fulltime, unique: true
    add_index :time_ds, :hour
    add_index :time_ds, :minute
  end
end
