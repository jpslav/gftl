class RenameRankingToPositionInPsrankings < ActiveRecord::Migration
  def self.up
    rename_column :preseason_rankings, :ranking, :position
  end

  def self.down
    rename_column :preseason_rankings, :position, :ranking
  end
end
