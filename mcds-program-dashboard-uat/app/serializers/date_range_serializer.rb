class DateRangeSerializer < ActiveModel::Serializer
  attributes  :id,
              :start_date,
              :end_date

  has_one :date_type, serializer: DateTypeSerializer
end
