class ColorBlock < ActiveRecord::Base
  has_and_belongs_to_many :programs
  has_and_belongs_to_many :users

  validates_presence_of :name, :start_hex
  validates_format_of :start_hex, :with => /(?<=#)(?<!^)(\h{6}|\h{3})/i, :on => :create
  validates_format_of :end_hex, :with => /(?<=#)(?<!^)(\h{6}|\h{3})/i, :on => :create, :allow_blank => true

end
