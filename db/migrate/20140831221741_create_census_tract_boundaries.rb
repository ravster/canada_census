class CreateCensusTractBoundaries < ActiveRecord::Migration
  def change
    create_table :census_tract_boundaries, id: false do |t|
      t.string :ctuid
      t.string :ctname
      t.string :cmauid
      t.string :cmaname
      t.string :cmatype
      t.string :cmapuid
      t.string :pruid
      t.string :prname
      t.column :geom, :geometry
    end

    add_index :census_tract_boundaries, :ctuid
    add_index :census_tract_boundaries, :geom, using: :gist
  end
end
