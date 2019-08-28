class CreateOffences < ActiveRecord::Migration[6.0]
  def change
    create_table :offences do |t|
      t.string :name
      t.string :description
      t.timestamps
    end
    add_index :offences, :name, unique: true
  end
end
