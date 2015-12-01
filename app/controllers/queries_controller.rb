class QueriesController < ApplicationController
	 before_action :authenticate_user!, only: [:saved]
	 skip_before_action :verify_authenticity_token, only: [:near_me]

	def index
		gon.current_user = current_user
		if params[:search]
			gon.current_user = current_user
			query = Query.new
			gon.geoJSON_bylocation = query.explore_by_location(params[:search])
			@location_info = gon.geoJSON_bylocation
		end
	end

	def saved
		query = Query.new	
		response = query.find_venue(params[:venue_id])
		query.city = response.location.city
		query.venue_id = params[:venue_id]
		query.title = response.name
		query.rating = response.rating
		query.address = response.location.formattedAddress
		query.description = "#{response.location.state}, #{response.location.country}"
		query.longitude = response.location.lng
		query.latitude = response.location.lat
		query.category = response.categories[0].name
		query.user_id = current_user.id
		query.icon_url = response.categories[0].icon.prefix + "bg_" + "32" + response.categories[0].icon.suffix
		query.image_url = response.photos.groups[0].items[0].prefix + "original" + response.photos.groups[0].items[0].suffix
		query.save
	end
		#Button 'show all' should point to seperate get 
		# 	with all saved posts of the current user. accessed only through authenticate_user.

		# response.photos.groups[0].items.count

	def show
		query = Query.new
		response = query.find_venue(params[:venue_id])
		tips = []
		images = []
		timings = []

		response.tips.groups[0].items.each do |item|
			if item['text']
				tips << item['text']
			end
		end

		response.photos.groups[0].items.each do |item|
			if item['prefix']
				images << item['prefix'] + "original" + item['suffix']
			end
		end
		
		if response['popular']['timeframes']
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
		else 
		render json: []
		end
	end

end

