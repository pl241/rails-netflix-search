class AddGenresToVideos < ActiveRecord::Migration[5.1]
  def change
    add_column :videos, :genres, :string, :array => true
  end
end
