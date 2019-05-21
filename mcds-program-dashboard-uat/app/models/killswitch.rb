class Killswitch < ActiveRecord::Base
  validates :name, uniqueness: true

  def self.enabled_check(key)
    result = self.where(name: key)

    # If no key found, it can't be killed, so enabled
    return true unless result.length > 0

    # If key found, check if kill is on
    !result.first.killed
  end

  def self.email_enabled?
    self.enabled_check('email')
  end

  def self.new_user_notification_enabled?
    self.enabled_check('new_user_notification')
  end

  def self.capture_behavior_enabled?
    self.enabled_check('capture_behavior')
  end
end
