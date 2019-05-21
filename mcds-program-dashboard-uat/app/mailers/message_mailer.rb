class MessageMailer < ActionMailer::Base

  def send_message(message, users)
    @message = Message.find(message.id)
    mail(
      from: 'no-reply@mcsourceonline.com',
      bcc: users,
      subject: message.subject
    )
  end

  def no_metadata_found(template_name, asset)
    @template_name = template_name
    @asset =  asset

    mail(
      from: 'no-reply@tukaiz.com',
      to: 'mcsource@tukaiz.com',
      subject: "#{Rails.env}-McSource Lookup Table Update Worker"
    )
  end

  def no_program_found(program_id, asset)
    @program_id = program_id
    @asset =  asset

    mail(
      from: 'no-reply@tukaiz.com',
      to: 'mcsource@tukaiz.com',
      subject: "#{Rails.env}-McSource Program Update Info"
    )
  end

  def dam_update_asset_email(response, processed_asset)
    @response = response
    @processed_asset =  processed_asset
    @auth_key =  auth_key

    mail(
      from: 'no-reply@tukaiz.com',
      to: 'mcsource@tukaiz.com',
      subject: "#{Rails.env}-Dam Asset Update Worker"
    )
  end

  def dam_lookup_table_success(email)
    mail(
      from: 'no-reply@tukaiz.com',
      to: email,
      subject: "#{Rails.env}-McSource Lookup Table Update Worker Complete"
    )
  end

  def dam_lookup_table_fail(response, request_body, email, auth_key)
    @request_body = request_body
    @response = response
    @initiator = email
    @auth_key = auth_key

    mail(
      from: 'no-reply@tukaiz.com',
      to: email,
      subject: "#{Rails.env}-McSource Lookup Table Update Worker Fail"
    )
  end

  def dam_program_update_fail(response, request_body, auth_key)
    @response = response
    @request_body = request_body
    @auth_key= auth_key

    mail(
      from: 'no-reply@tukaiz.com',
      to: 'mcsource@tukaiz.com',
      subject: "#{Rails.env}-Dam Asset Update Worker"
    )
  end

  def new_user_message(user)
    @user = user
    mail(
      from: 'no-reply@tukaiz.com',
      to: 'mcsource@tukaiz.com',
      subject: "McSource New User Login"
    )
  end
end
