class DocumentNote < ActiveRecord::Base
  belongs_to :document
  belongs_to :note
end
