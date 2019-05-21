class Message < ActiveRecord::Base
  # ASSOCIATIONS
  belongs_to :user

  has_many :message_users, dependent: :destroy
  has_many :users, through: :message_users

  has_many :contact_list_messages, dependent: :destroy
  has_many :contact_lists, through: :contact_list_messages

  has_many :geography_messages, dependent: :destroy
  has_many :geographies, through: :geography_messages

  has_many :resources, as: :resourceable, dependent: :destroy
  accepts_nested_attributes_for :resources, allow_destroy: true, reject_if: proc { |attr| %i[file].any?{|a| attr[a].blank? } }

  # VALIDATIONS
  validates_presence_of :subject

  # CALLBACKS

  before_save :sanitize_html

  # SCOPES
  scope :unsent, -> { where(sent: false, archived: false) }
  scope :unarchived, -> { where(archived: false) }
  scope :scheduled_to_be_sent, -> { where("send_date <= ?", Time.now) }
  scope :scheduled_to_be_published, -> { where("publish_date <= ?", Time.now) }
  scope :scheduled_to_be_archived, -> { where("archive_date <= ?", Time.now) }
  scope :published, -> { where.not(publish_date: nil) }

  scope :for_users, -> (user_ids) {
    where(:user_id => user_ids) if user_ids && user_ids.any?
  }

  scope :for_user, -> (user_id) {
    where(:user_id => user_id) if user_id.present?
  }

  scope :for_specific_geographies, -> (geography_ids) {
    joins(:geographies).where(geographies: {id: geography_ids}) if geography_ids.present?
  }

  scope :search_message, -> (search_field) {
    where("subject LIKE ? or content LIKE ?", "%#{search_field}%", "%#{search_field}%") if search_field.present?
  }

  scope :published_for_date_range, -> (start_date, end_date = nil) {
    start_date = start_date.to_datetime.beginning_of_day
    if end_date
      end_date.to_datetime.end_of_day
    else
      if start_date.present?
        end_date = start_date.to_date + 1
        end_date.to_datetime.end_of_day
      end
    end

    published.
    where("publish_date between ? and ?", start_date, end_date)
  }

  scope :for_event_category, -> (event_type_name){
    geo_type_id = GeographyType.find_by_name(event_type_name).try(:id)

    includes(:geographies). where(geographies: {geography_type_id: geo_type_id}) if geo_type_id
  }

  scope :viewable_messages, -> (user) {
    # return if user.tukaiz_super_admin? || user.admin? #remove to restrict which messages admins can see

    #This will return all national coop messages, all messages for user assigned coops,
    # all emails FROM the user, and all PUBLISHED emails TO the user

    # IN SQL:
    # SELECT messages.* FROM messages LEFT OUTER JOIN geography_messages ON messages.id = geography_messages.message_id LEFT OUTER JOIN message_users ON messages.id = message_users.message_id LEFT OUTER JOIN geographies ON geographies.id = geography_messages.geography_id LEFT OUTER JOIN geography_users ON geographies.id = geography_users.geography_id WHERE geography_users.user_id = 30 OR geographies.name = 'National'OR (messages.delivery_type = 'email' AND (messages.user_id = 30 OR (messages.sent = 1 AND message_users.user_id = 30)))

    message_table = Message.arel_table
    geog_users_table = GeographyUser.arel_table
    geog_message_table = GeographyMessage.arel_table
    message_user_table = MessageUser.arel_table
    geog_table = Geography.arel_table
    outer_join = Arel::Nodes::OuterJoin

    distinct.where(
      geog_users_table[:user_id].eq(user.id).or(
        geog_table[:name].eq('National').or(
          message_table[:delivery_type].eq('email').and(
            message_table[:user_id].eq(user.id).or(
              message_table[:sent].eq(true).and(message_user_table[:user_id].eq(user.id))
            )
          )
        )
      )
    ).joins(
      message_table.join(
        message_user_table, outer_join
      ).on(
        message_table[:id].eq(
          message_user_table[:message_id]
        )
      ).join_sources
    ).joins(
      message_table.join(
        geog_message_table, outer_join
      ).on(
        message_table[:id].eq(
          geog_message_table[:message_id]
        )
      ).join_sources
    ).joins(
      message_table.join(
        geog_table, outer_join
      ).on(
        geog_table[:id].eq(
          geog_message_table[:geography_id]
        )
      ).join_sources
    ).joins(
      message_table.join(
        geog_users_table, outer_join
      ).on(
        geog_table[:id].eq(
          geog_users_table[:geography_id]
        )
      ).join_sources
    )
  }


  # CLASS METHODS
  def self.for_calendar(opts = {})
    published_for_date_range(opts[:start_date], opts[:end_date]).
    for_event_category(opts[:event_category]).
    for_user(opts[:user]).
    for_specific_geographies(opts[:coops]).
    search_message(opts[:search_field])
  end

  def self.find_and_send_all_unsent_messages
    messages = self.unsent.scheduled_to_be_sent #+ self.unsent.scheduled_to_be_published   ###Currently we do not want calendar messages emailed
    send_all_messages(messages)
  end

  def self.send_all_messages(messages)
    messages.each do |message|
      begin
        message.update_attributes(sent: true) if message.send_email
      rescue
        Message.create(sent: true, message_users: User.where(email: 'mcsource@tukaiz.com'), content: "message id: #{message.id} errored")
      end
    end
  end

  def self.remove_scheduled_messages
    messages = self.scheduled_to_be_archived
    messages.each do |message|
      message.update_attributes(archived: true)
    end
  end

  def self.for_single_day(start_date)
    published.
    where("publish_date between ? and ?", start_date.beginning_of_day, start_date.end_of_day)
  end


  # INSTANCE METHODS
  def send_email
    recipients = if users.blank?
      # check the message's geographies and gather users
      geographies.collect(&:users).flatten.uniq.collect(&:email)
    else
      self.users.collect(&:email)
    end
    MessageMailer.send_message(self, recipients).deliver_now
  end

  def sanitize_html
    body = self.content
    body.gsub!(/(<)(script[\s\S]*?)(>)/, '&lt\2&gt')
    body.gsub!(/(<)(\/script[\s\S]*?)(>)/, '&lt\2&gt')
    body.gsub!(/(<)(iframe[\s\S]*?)(>)/, '&lt\2&gt')

    # body.gsub!(/>/, '&gt')
    self.content = body
  end
end
