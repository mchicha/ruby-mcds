class DocumentElement < ActiveRecord::Base
  belongs_to :document
  belongs_to :element
end
