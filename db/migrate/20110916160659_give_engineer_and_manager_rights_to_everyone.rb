class GiveEngineerAndManagerRightsToEveryone < ActiveRecord::Migration
  def self.up
    UserWorkspaceMembership.all.each do |member|
      member.engineer = true
      member.manager  = true
      member.save
    end
  end

  def self.down
  end
end
