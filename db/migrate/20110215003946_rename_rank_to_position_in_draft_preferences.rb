class RenameRankToPositionInDraftPreferences < ActiveRecord::Migration
  def self.up
    rename_column :draft_preferences, :rank, :position
  end

  def self.down
    rename_column :draft_preferences, :position, :rank
  end
end
