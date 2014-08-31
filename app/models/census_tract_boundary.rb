class CensusTractBoundary < ActiveRecord::Base
  before_validation :create_geom_from_geojson

  private
  def create_geom_from_geojson
    db = ActiveRecord::Base.connection
    self.geom = db.select_value("select ST_SetSRID(ST_GeomFromGeoJSON(#{db.quote self.geom}), 4326)")
  end
end
