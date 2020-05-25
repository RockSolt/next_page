class CreateCoaches < ActiveRecord::Migration[6.0]
  def change
    create_table :coaches do |t|
      t.references :team
      t.string :name

      t.timestamps
    end
  end
end
