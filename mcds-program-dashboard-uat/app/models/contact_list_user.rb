class ContactListUser < ActiveRecord::Base
  belongs_to :contact_list
  belongs_to :user
end
