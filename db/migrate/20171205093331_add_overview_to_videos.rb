class AddOverviewToVideos < ActiveRecord::Migration[5.1]
  def change
    add_column :videos, :overview, :text
  end
end
