module AlertsHelper

  def archive_or_activate(alert)
    alert.unarchived? ? ' Archive' : ' Activate'
  end

  def action_class(alert)
    alert.unarchived? ?  'fa fa-archive' : 'fa fa-plus-circle'
  end

  def alert_title(alert)
    "#{alert_type(alert)} Alert"
  end

  def alert_type(alert)
    alert.alertable_type.present? ? alert.alertable_type : 'General'
  end

  def alert_link(alert)
    case alert_type(alert)
    when 'Program'
      link_to(alert.alertable.try(:name), program_path(alert.alertable))
    when 'Schematic'
      link_to(alert.alertable.try(:name), "/schematics/#{alert.alertable_id}/view")
    end
  end


  def alert_display_status(alert)
    "#{alert.status}#{' - All' if alert.show_all?}"
  end

end
