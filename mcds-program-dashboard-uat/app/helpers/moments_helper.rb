module MomentsHelper

  def archive_or_activate(moment)
    moment.unarchived? ? ' Archive' : ' Activate'
  end

  def action_class(moment)
    moment.unarchived? ?  'fa fa-archive' : 'fa fa-plus-circle'
  end

  def alert_title(moment)
    "#{alert_type(moment)} Alert"
  end

  def moment_type(moment)
    moment.momentable_type || 'General'
  end

  def moment_link(moment)
    case moment_type(moment)
    when 'Program'
      link_to(moment.momentable.try(:name), program_path(moment.momentable))
    when 'Schematic'
      link_to(moment.momentable.try(:name), "/schematics/#{moment.momentable_id}/view")
    end
  end
end
