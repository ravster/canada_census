# Installation
## Ingredients

You will need
- Postgresql 9.4
- PostGIS
- Jruby
- StatCan census tract boundaries
- gdal
- StatCan 'NHS data for a complete geographic level' for Census Tracts, in CSV format

## Setup

- Create a user and database in Postgres that the application can connect to.
- Call `CREATE EXTENSION postgis;` on that database.
- Run `bundle exec rake db:migrate` in the app's root.
- Unzip the census tract boundaries file and run `ogr2ogr -f 'GeoJSON' -t_srs epsg:4326 i.json gct_000b11a_e.shp` on it to convert it to GeoJSON format with latitudes and longitudes.
- You might have to force the file into UTF8 by `iconv -f ISO-8859-1 -t UTF-8 orig.json > new.json`
- Import the census tract boundary data by `bundle exec rake insert_into_db:census_tract_boundaries[../../Downloads/ct/c.json]`
- Import the census tract information by `bundle exec rake insert_into_db:census_tract_info[../../Downloads/ct/99-004-XWE2011001-401-ONT.csv]`

# Run

- `bundle exec rails s -p 3000`
- Go to http://localhost:3000
