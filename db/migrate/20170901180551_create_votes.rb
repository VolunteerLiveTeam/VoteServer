class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.belongs_to :candidate, foreign_key: true
      t.integer :ballot_id
      t.integer :preference

      t.timestamps
    end
  end
end
