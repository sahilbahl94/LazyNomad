class QueriesController < ApplicationController
	# before_action :authenticate_user!, only: [:saved]
	 skip_before_action :verify_authenticity_token, only: [:near_me]

	def index
		if params[:search]
			query = Query.new
			gon.geoJSON_bylocation = query.explore_by_location(params[:search])
			@location_info = gon.geoJSON_bylocation
		end
	end

	def saved
		# if certain condition is met, create a record in database 
		# 	that saves all the info of the venue clicked(probably a post method).
		# 	then the javascript save button should changed to saved (or any other alert method),
		# 	and the record is creted. Button 'show all' should point to seperate get 
		# 	with all saved posts of the current user. accessed only through authenticate_user.

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

