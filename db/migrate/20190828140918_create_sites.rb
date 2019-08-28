class CreateSites < ActiveRecord::Migration[6.0]
  def change
    create_table :sites do |t|
      t.string :neighbourhood
      t.string :block
      t.timestamps
    end
    add_index :sites, [:neighbourhood, :block], unique: true
    add_index :sites, :neighbourhood
    add_index :sites, :block
  end
end
