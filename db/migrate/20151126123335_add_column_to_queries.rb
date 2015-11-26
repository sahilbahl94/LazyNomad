class AddColumnToQueries < ActiveRecord::Migration
  def change 	
  	add_column :queries, :city, :string
  	add_column :queries, :venue_id, :string
  	add_column :queries, :title, :string
  	add_column :queries, :description, :string
  	add_column :queries, :category, :string
  	add_column :queries, :rating, :float
  	add_column :queries, :icon_url, :string
  	add_column :queries, :address, :string
  	add_column :queries, :image_url, :string
  	add_column :queries, :user_id, :integer
  end
end

#t.belongs_to :user, index:true
