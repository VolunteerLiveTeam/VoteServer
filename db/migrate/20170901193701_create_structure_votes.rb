class CreateStructureVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :structure_votes do |t|
      t.boolean :value

      t.timestamps
    end
  end
end
