class ChangeAvgVoteToFloat < ActiveRecord::Migration[5.1]
  def change
    change_column :videos, :avg_vote, :float
  end
end
