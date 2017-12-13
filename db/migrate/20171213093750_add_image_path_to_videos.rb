class AddImagePathToVideos < ActiveRecord::Migration[5.1]
  def change
    add_column :videos, :image_path, :string
  end
end
