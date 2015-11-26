class QueriesController < ApplicationController
	# before_action :authenticate_user!, only: [:saved]
	
	def index
		if params[:search]
			query = Query.new
			gon.geoJSON = query.get_info(params[:search])
			@location_info = gon.geoJSON
		end
	end

	def saved

	end

end


