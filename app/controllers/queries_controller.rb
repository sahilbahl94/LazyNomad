class QueriesController < ApplicationController
	 before_action :authenticate_user!, only: [:saved, :saved_places]
	 skip_before_action :verify_authenticity_token, only: [:near_me, :saved]

	
	def index
		query = Query.new
		gon.current_user = current_user
		gon.geoformat = query.geo_format
		if params[:search]
			gon.current_user = current_user
			gon.geoJSON_bylocation = query.explore_by_location(params[:search])
			@location_info = gon.geoJSON_bylocation
			render json: @location_info
		end
	end

	def saved
		query = Query.new
		response = query.find_venue(params[:venue_id])
		check_database = Query.where(user_id: current_user.id)
		user_saved = false
		
		check_database.each do |venue| 
			if venue.venue_id == params[:venue_id]
				user_saved = true
				break
			end
		end

		if user_saved == false 
			Query.create(
				city: response.location.city,
				venue_id: params[:venue_id],
				title: response.name,
				rating: response.rating,
				address: response.location.formattedAddress,
				description: "#{response.location.state}, #{response.location.country}",
				longitude: response.location.lng,
				latitude: response.location.lat,
				category: response.categories[0].name,
				user_id: current_user.id,
				icon_url: response.categories[0].icon.prefix + "bg_" + "32" + response.categories[0].icon.suffix,
				image_url: response.photos.groups[0].items[0].prefix + "original" + response.photos.groups[0].items[0].suffix
			)
		end
		render json: {saved: user_saved}
	end

	def show
		query = Query.new
		response = query.find_venue(params[:venue_id])
		tips = []
		images = []
		timings = []

		response.tips.groups[0].items.each do |item|
			if item['text'] != nil
				tips << item['text']
			end
		end

		response.photos.groups[0].items.each do |item|
			if item['prefix'] != nil
				images << item['prefix'] + "original" + item['suffix']
			end
		end
		if response['popular'] != nil
			timings << response['popular']['timeframes']
		end
		render json: {tips: tips, images: images, timings: timings}
	end

	def near_me
		if params[:coords]
		coords = params[:coords].split(",")
		lat = coords[0].to_f
		lng = coords[1].to_f
		query = Query.new
		gon.geoJSON_bycoords = query.explore_by_coords("#{lat}, #{lng}")
		@location_info = gon.geoJSON_bycoords
		render json: @location_info
		end
	end

	def saved_places
		query = Query.new
		user = User.find_by(id: current_user.id)
		places = user.queries
		geo_array = []
		places.each do |place|
			geo = query.geo_format
			geo[:geometry][:coordinates] << place.longitude
			geo[:geometry][:coordinates] << place.latitude
			geo[:properties][:city] = place.city
			geo[:properties][:title] = place.title
			geo[:properties][:rating] = place.rating
			geo[:properties][:category] = place.category
			geo[:properties][:description] = place.description
			geo_array << geo
		end
		render json: geo_array
	end

end

