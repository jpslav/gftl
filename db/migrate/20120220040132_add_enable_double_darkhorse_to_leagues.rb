class AddEnableDoubleDarkhorseToLeagues < ActiveRecord::Migration
  def self.up
    add_column :leagues, :double_darkhorse, :boolean
  end

  def self.down
    remove_column :leagues, :double_darkhorse
  end
end
