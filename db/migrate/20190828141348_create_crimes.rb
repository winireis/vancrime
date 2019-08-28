class CreateCrimes < ActiveRecord::Migration[6.0]
  def change
    create_table :crimes do |t|
      t.references :offence
      t.references :site
      t.references :date_d
      t.references :time_d     
      t.integer :counter, null: false, default: 1
      t.timestamps
    end
  end
end
