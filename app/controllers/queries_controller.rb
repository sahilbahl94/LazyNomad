class QueriesController < ApplicationController
	def index
		if params[:search]
			query = Query.new
			gon.geoJSON = query.get_info(params[:search])
			@location_info = gon.geoJSON
		end
	end
end


