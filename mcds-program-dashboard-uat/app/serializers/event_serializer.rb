class EventSerializer < ActiveModel::Serializer
  attributes :start, :count, :title, :imageurl

  def title
    if object.is_a?(Program)
      object["geography_type_id"].nil? ? 'National' : GeographyType.find(object['geography_type_id']).name
    else
      'Message'
    end
  end

  def start
    object.is_a?(Program) ? object["start_date"].strftime("%Y-%m-%d") : object["published_date"]
  end

  def count
  	object["program_count"]
  end

  def imageurl
    if object.is_a?(Program)
      object["geography_type_id"].nil? ? "national" : "coop"
    else
      "event"
    end
  end
end
