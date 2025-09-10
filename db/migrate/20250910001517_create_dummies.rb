class CreateDummies < ActiveRecord::Migration[8.0]
  def change
    create_table :dummies do |t|
      t.string :name

      t.jsonb :spotify_hash, default: {}

      t.timestamps
    end
  end
end
