class CreateVoters < ActiveRecord::Migration[5.1]
  def change
    create_table :voters do |t|
      t.string :name
      t.string :url_slug
      t.datetime :voted_at

      t.timestamps
    end
  end
end
