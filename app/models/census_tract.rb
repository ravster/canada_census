class CensusTract < ActiveRecord::Base
  self.primary_key = :ctuid
  before_create :create_geom_from_geojson

  def self.return_tracts_as_json_string options={}
    db = ActiveRecord::Base.connection

    constraints = []
    if options[:province_name].present?
      constraints << "prname = #{db.quote options[:province_name]}"
    end
    if options[:cma_name].present?
      constraints << "cmaname = #{db.quote options[:cma_name]}"
    end
    if options[:individual_median_combined_max].present?
      constraints << "(data->'Individual Median Income'->>'combined')::INT < #{db.quote options[:individual_median_combined_max]}"
    end
    if options[:individual_median_combined_min].present?
      constraints << "(data->'Individual Median Income'->>'combined')::INT > #{db.quote options[:individual_median_combined_min]}"
    end
    constraints = if constraints.present?
                    "WHERE #{constraints.join(" AND ")}"
                  else
                    nil
                  end

    db.select_value(
      "WITH records AS ( SELECT ctuid, ctname, cmauid, cmaname, cmatype, cmapuid, pruid, prname, data, ST_AsGeoJSON(geom) AS geom
      FROM census_tracts )
      SELECT array_to_json(array_agg(row_to_json(records))) FROM records"
      )
  end

  private
  def create_geom_from_geojson
    db = ActiveRecord::Base.connection
    self.geom = db.select_value("select ST_SetSRID(ST_GeomFromGeoJSON(#{db.quote self.geom}), 4326)")
  end
end
