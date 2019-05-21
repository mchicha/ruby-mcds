module MessagesHelper

  def convert_date_for_input(attribute)
    attribute ? attribute.strftime('%m/%d/%Y %I:%M %p') :  ""
  end

  def sent_to(users)
    if users.length == 1
      users.first.email
    else
      "#{users.length} users"
    end
  end

  def user_can_see_message?(message)
    (
      message.delivery_type == "published" &&
      (message.geographies.collect(&:id) & current_user.geographies.collect(&:id)).blank?
    ) ? false : true
  end

end
