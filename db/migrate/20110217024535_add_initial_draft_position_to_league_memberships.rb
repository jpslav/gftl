class AddInitialDraftPositionToLeagueMemberships < ActiveRecord::Migration
  def self.up
    add_column :league_memberships, :initial_draft_position, :integer
  end

  def self.down
    remove_column :league_memberships, :initial_draft_position
  end
end
