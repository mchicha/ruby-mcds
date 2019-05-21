module Captureable
  extend ActiveSupport::Concern

  def dont_capture_user_behavior
    @skip_capture = true
  end

  def capture_user_hitting_route(opts = {})
    return if skip_capture

    event = "Visit #{params[:controller]}:#{params[:action]}"

    base_opts = {
      event:      event,
      user_id:    current_user.try(:id),
      session_id: session['session_id'],
      user_role:  current_user.try(:role)
    }

    if params[:id]
      base_opts[:object_id] = params[:id].try(:to_i)
    end

    if current_user.try(:selected_geography)
      base_opts[:geography] = current_user.selected_geography.id
    end

    if @capture_params.present?
      base_opts.merge(@capture_params)
    end

    Capture.generate(
      base_opts.merge(opts)
    )
  end

  def skip_capture
    (!Killswitch.capture_behavior_enabled? || @skip_capture || current_user.try(:tukaiz_super_admin?))
  end

end
