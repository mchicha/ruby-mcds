class Forms::Element < Forms::Base

  property :name
  property :editable, type: Virtus::Attribute::Boolean
  property :id, type: Integer
  property :zindex, type: Integer
  property :layout_id, type: Integer
  property :primary_dam_asset_id, type: Integer
  property :primary_dam_asset_path
  property :secondary_dam_asset_id, type: Integer
  property :secondary_dam_asset_path
  property :primary_program_id, type: Integer
  property :secondary_program_id, type: Integer
  property :grayscale, type: Virtus::Attribute::Boolean
  property :values, type: Hash

  def last_modified_by(user)
    model.schematics.each do |schematic|
      schematic.last_modified_by_id = user.id
      schematic.save
    end
  end

end
