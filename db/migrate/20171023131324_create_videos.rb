class CreateVideos < ActiveRecord::Migration[5.1]
  def change
    create_table :videos do |t|
      t.string :title
      t.string :media_type
      t.date :release_date
      t.integer :popularity
      t.integer :avg_vote

      t.timestamps
    end
  end
end
