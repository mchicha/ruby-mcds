class Forms::Schematic < Forms::Base

  property :name, type: String
  property :status, type: String
  property :sch_type, type: Integer
  property :release_date, type: DateTime
  property :end_date, type: DateTime
  property :status
  property :parent_id, type: Integer
  property :source_id, type: Integer
  property :last_modified_by_id, type: Integer

  validates :name, presence: true

end
