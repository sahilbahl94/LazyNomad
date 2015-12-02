class Query < ActiveRecord::Base

belongs_to :user

	def setup
		@foursquare_id = ENV["foursquare_id"]
		@foursquare_secret = ENV["foursquare_secret"]
		@client = Foursquare2::Client.new(:client_id => @foursquare_id, :client_secret => @foursquare_secret)
	end

	def explore_by_location(search_term)
		response = setup.explore_venues(:near => search_term, :v => 20140806, :m => "foursquare", :section => "sights", :venuePhotos => 1)
		get_info(response)
		#use Query.create(name: "ef", something.. ) here.
	end

	def explore_by_coords(coords)
		response = setup.explore_venues(:ll => coords, :v => 20140806, :m => "foursquare", :section => "sights", :venuePhotos => 1)
		get_info(response)
	end

	def find_venue(id)
		response = setup.venue(id, :v => 20140806)
	end

	def venue_tips(id)
		response = setup.venue_tips(id, :v => 20140806)
	end

	def get_info(api_response)
		results = []
		api_response.groups[0].items do |item|
			item.each do |i|
				location_info = geo_format
				icon_size = "32"
				image_size = "original"
				location_info[:properties][:city] = i.venue.location.city
				location_info[:properties][:venue_id] = i.venue.id
				location_info[:properties][:title] = i.venue.name
				location_info[:properties][:category] = i.venue.categories[0].name
				location_info[:geometry][:coordinates] << i.venue.location.lng
				location_info[:geometry][:coordinates] << i.venue.location.lat
				location_info[:properties][:rating] = i.venue.rating
				location_info[:properties][:icon][:iconUrl] = i.venue.categories[0].icon.prefix + "bg_" + icon_size + i.venue.categories[0].icon.suffix
				location_info[:properties][:image_url] = i.venue.photos.groups[0].items[0].prefix + image_size + i.venue.photos.groups[0].items[0].suffix
				location_info[:properties][:address] = i.venue.location.formattedAddress
				location_info[:properties][:description] = i.tips[0].text
				results << location_info
			end
		end
		results
	end

	def geo_format
	location_info = {
		:type => "Feature", 
		:geometry => {
			:type => "Point",
			:coordinates => []
		},
		:properties => {
			"marker-color": "#63b6e5",
			"marker-size": "large",
    		"marker-symbol": "rocket",
			:icon => {}	
		}
	}
	end

end