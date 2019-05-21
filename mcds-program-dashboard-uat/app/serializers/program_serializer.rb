class ProgramSerializer < ActiveModel::Serializer
  attributes  :id,
              :name,
              :pop_start_dates

  has_many :color_blocks
  has_many :geographies

  def pop_start_dates
    # We do not always need the pop dates. Currently needed for the legend in the print app. If not needed, do not get them
    if self.scope.try(:is_a?, Hash) && self.scope[:inherited_serialization_options] && self.scope[:inherited_serialization_options][:include_date_ranges]
      ActiveModel::ArraySerializer.new(
        object.date_ranges.select{ |date_range| ['pop_install', 'pop_take_down'].include?(date_range.date_type.name) },
        each_serializer: DateRangeSerializer
      )
    end
  end
end
