namespace :insert_into_db do
  task :census_tract_boundaries, [:file] => :environment do |task, args|
    json = MultiJson.load(File.read(args.file))["features"].each do |place|
      out = place["properties"].each_pair.with_object({}) do |(key, value), final|
        final[key.downcase.to_sym] = value
      end
      out[:geom] = MultiJson.dump(place["geometry"])
      CensusTractBoundary.create! out
    end
  end
end
