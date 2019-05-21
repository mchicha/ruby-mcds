class User < ActiveRecord::Base
  include TkmlAuth::User

  has_many :programs
  has_many :messages
  has_many :calendars
  has_many :geography_users
  has_many :geographies, through: :geography_users
  has_many :schematics, through: :geographies
  has_many :alerts
  belongs_to :selected_geography, class_name: "Geography", foreign_key: 'selected_geography_id'

  has_and_belongs_to_many :color_blocks
  has_and_belongs_to_many :agencies

  has_many :messages
  has_many :message_users, through: :messages

  has_many :contact_lists
  has_many :contact_list_users, through: :contact_lists

  scope :coop_schem, -> { joins(:schematic).where.not(parent_id: nil) }
  enum role: [:admin, :inputter, :leadership, :us_read_only, :tukaiz_super_admin]

  # TODO if this is ever reused in another model, break out into a module
  after_create :check_predefined_atttributes, unless: :skip_predefined_attributes
  after_create :new_user_notification
  attr_accessor :skip_predefined_attributes
  # # # # # # # # # # # # # # # # # # #

  def full_name
    last_name.blank? ? first_name : "#{first_name} #{last_name}"
  end

  def admin_or_super_admin?
    self.role == 'admin' || self.role == 'tukaiz_super_admin'
  end

  def read_only_or_leadership?
    self.role == 'us_read_only' || self.role == 'leadership'
  end

  def inputter_assigned_to_geography_ids?(geog_ids)
    return false unless inputter?
    # method takes an array, so must check if a user is in all of the given ids
    user_geog_ids = geographies.pluck(:id)
    !geog_ids.detect{|g_id| !user_geog_ids.include?(g_id)}
  end


  def new_user_notification
    if Killswitch.new_user_notification_enabled?
      MessageMailer.new_user_message(self).deliver_now
    end
  end



  # TODO if this is ever reused in another model, break out into a module
  def check_predefined_atttributes
    send_ons = [0]

    send_ons << created_at_changed? ? 1 : 2

    predefiners = PredefinedAttribute.where(send_on: send_ons, table: 'users')

    predefiners.each do |predef|
      if self.send(predef.column) == predef.value
        predef.assign_values(self)
      end
    end
  end
  # # # # # # # # # # # # # # # # # # # # # # # # # # # #

end
