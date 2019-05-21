module ColorBlocksHelper

  def end_color(color)
    color.end_hex.blank? ? color.start_hex : color.end_hex
  end

end
