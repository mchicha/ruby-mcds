class ContactListMessage < ActiveRecord::Base
	belongs_to :contact_list
	belongs_to :message
end
