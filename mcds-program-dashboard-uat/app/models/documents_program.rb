class DocumentsProgram < ActiveRecord::Base
  belongs_to :document
  belongs_to :program

  validates :document, :program, presence: true
end
