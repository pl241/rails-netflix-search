class RemoveGenresFromVideos < ActiveRecord::Migration[5.1]
  def change
    remove_column :videos, :genres, :string
  end
end
