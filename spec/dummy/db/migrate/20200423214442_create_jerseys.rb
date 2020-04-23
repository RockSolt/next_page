class CreateJerseys < ActiveRecord::Migration[6.0]
  def change
    create_table :jerseys do |t|
      t.integer :number
      t.boolean :home

      t.timestamps
    end
  end
end
