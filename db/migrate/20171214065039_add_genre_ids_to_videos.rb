class AddGenreIdsToVideos < ActiveRecord::Migration[5.1]
  def change
    add_column :videos, :genre_ids, :integer, :array => true
  end
end
