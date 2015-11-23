class Query < ActiveRecord::Base

	def exploreby_location(location)
		foursquare_id = ENV["foursquare_id"]
		foursquare_secret = ENV["foursquare_secret"]

		client = Foursquare2::Client.new(:client_id => foursquare_id, :client_secret => foursquare_secret )
		response = client.explore_venues(:near => location, :v => 20140806, :m => "foursquare", :section => "sights", :venuePhotos => 1)
		#use Query.create(name: "ef", something.. ) here.
	end

	def get_info(location)
		results = []
		response = exploreby_location(location)
		response.groups[0].items do |item|
			item.each_with_index do |i, index|
				location_info = {}
				icon_size = "32"
				image_size = "original"

				location_info[:city] = location
				location_info[:venue_id] = i.venue.id
				location_info[:name] = i.venue.name
				location_info[:category] = i.venue.categories[0].name
				location_info[:lat] = i.venue.location.lat
				location_info[:lng] = i.venue.location.lng
				location_info[:rating] = i.venue.rating
				location_info[:icon_url] = i.venue.categories[0].icon.prefix + "bg_" + icon_size + i.venue.categories[0].icon.suffix
				location_info[:image_url] = i.venue.photos.groups[0].items[0].prefix + image_size + i.venue.photos.groups[0].items[0].suffix
				results << location_info
			end
		end
		results
	end
end
	


	# BASE_URL = "https://api.foursqaure.com/v2/"
	# def initialise(neighborhood, filter)
	# 	@neighbourhood = neighborhood
	# 	@filter = filter
	# end

	# def coord
	# 	coord = @neighborhood.coordinates.sample
	# 	"#{coord.lat},#{coord.lon}"
	# end

	# def venue_search_url
	# 	BASE_URL + "venues/explore?" + {
	# 		client_id: Rails.application.secrets.foursqaure_id,
	# 		client_secret: Rails.application.secrets.foursqaure_secret,
	# 		limit: 50,
	# 		ll: coord,
	# 		v: "20130118",
	# 		m: "swarm",
	# 		openNow: true, 
	# 		section: @filter
	# 	}.to_query
	# end

	# def connect 
	# 	Farady.new(:url => BASE_URL) do |faraday|
	# 		faraday.response :logger
	# 		faraday.adapter Farady.default_adapter
	# 	end
	# end


	# def get_establishments_raw
	# 	connect.get venue_search_url
	# end

	# def get_establishments
	# 	venue = JSON.load(get_establishments_raw.body)
	# 	venue.map { |v| venue['response']['groups'].first['items']}.flatten	
	# end

	# def establish_establishments
	# 	get_establishments.map { |i| i['venue']}
	# end

