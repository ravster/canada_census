class CreateCensusTractBoundaries < ActiveRecord::Migration
  def change
    create_table :census_tracts, id: false do |t|
      t.string :ctuid
      t.string :ctname
      t.string :cmauid
      t.string :cmaname
      t.string :cmatype
      t.string :cmapuid
      t.string :pruid
      t.string :prname
      t.json :data
      t.column :geom, :geometry
    end

    add_index :census_tracts, :ctuid
    add_index :census_tracts, :geom, using: :gist
  end
end
