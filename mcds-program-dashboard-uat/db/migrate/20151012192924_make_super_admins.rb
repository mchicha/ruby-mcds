class MakeSuperAdmins < ActiveRecord::Migration
  def up
    User.where("email LIKE '%@tukaiz.com%'").find_each do |tukaiz_user|
      tukaiz_user.update_attribute(:role, :tukaiz_super_admin)
    end
  end

  def down
    User.where("email LIKE '%@tukaiz.com%'").find_each do |tukaiz_user|
      tukaiz_user.update_attribute(:role, :admin)
    end
  end
end
