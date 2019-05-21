class ContactList < ActiveRecord::Base
  belongs_to :user
  has_many :contact_list_users
  has_many :users, through: :contact_list_users

  has_many :contact_list_messages
	has_many :messages, through: :contact_list_messages
end
