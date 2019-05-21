require 'rails_helper'

RSpec.describe DocumentNote, :type => :model do

  describe '#assosciations' do
    it { expect(DocumentNote.reflect_on_association(:document).macro).to   eq(:belongs_to) }
    it { expect(DocumentNote.reflect_on_association(:note).macro).to   eq(:belongs_to) }
  end

  describe '#schema' do
    it { should respond_to :document_id }
    it { should respond_to :note_id }
  end
end
