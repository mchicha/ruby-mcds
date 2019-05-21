class ContactListsController < ApplicationController
  before_action :require_user

  autocomplete :contact_list, :name, display_value: :name, full: true

  def index
    capture_user_hitting_route
    add_breadcrumb "Contact Lists", user_contact_lists_path(current_user)
  end

  private

  	def get_autocomplete_items(params)
	    search_term = "%#{params[:term]}%"
	    contact_list = params[:model].arel_table
	    ContactList.where(contact_list[:name].matches(search_term))
	  end

end
