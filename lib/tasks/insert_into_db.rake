namespace :insert_into_db do
  task :census_tract_boundaries, [:file] => :environment do |task, args|
    json = MultiJson.load(File.read(args.file))["features"].each do |place|
      out = place["properties"].each_pair.with_object({}) do |(key, value), final|
        final[key.downcase.to_sym] = value
      end
      out[:geom] = MultiJson.dump(place["geometry"])
      CensusTract.create! out
    end
  end

  task :census_tract_info, [:file] => :environment do |task, args|
    hash_to_enter = Hash.new {|hash, key| hash[key] = {} }
    CSV.foreach(args.file, headers: true, header_converters: :symbol, encoding: "iso-8859-1") do |row|
      row[:geo_code] = row[:geo_code].to_s
      if row[:topic] == "Income of individuals in 2010" &&
          row[:characteristic] == "  Median income ($)"
        hash_to_enter[row[:geo_code]].merge!(
          "Individual Median Income" => {
            combined: row[:total],
            male: row[:male],
            female: row[:female]
          }
        )
      end

      if row[:characteristic] == "  Median monthly shelter costs for owned dwellings ($)"
        hash_to_enter[row[:geo_code]].merge!(
          "Median monthly shelter costs for owned dwellings" => row[:total]
        )
      end
      if row[:characteristic] == "  Median monthly shelter costs for rented dwellings ($)"
        hash_to_enter[row[:geo_code]].merge!(
          "Median monthly shelter costs for rented dwellings" => row[:total]
        )
      end
    end

    db = ActiveRecord::Base.connection
    hash_to_enter.each_pair do |ctuid, data|
      CensusTract.where(ctuid: ctuid).first.update_attributes(data: data)
    end
  end
end
