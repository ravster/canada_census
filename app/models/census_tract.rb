class CensusTract < ActiveRecord::Base
  self.primary_key = :ctuid
  before_create :create_geom_from_geojson

  private
  def create_geom_from_geojson
    db = ActiveRecord::Base.connection
    self.geom = db.select_value("select ST_SetSRID(ST_GeomFromGeoJSON(#{db.quote self.geom}), 4326)")
  end
end
