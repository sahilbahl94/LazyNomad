class AddLatitudeAndLongitudeToQueury < ActiveRecord::Migration
  def change
    add_column :queries, :latitude, :float
    add_column :queries, :longitude, :float
  end
end
