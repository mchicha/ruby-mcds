class DocumentProgramSync

  # for each program id that changed
    # create new documents_program for the new program id if it's
      # not already created for another element out there
    # if the old program id is present
      # delete documents_programs that only exist for this element and the old program id

  attr_reader :element, :old_primary_program_id, :old_secondary_program_id

  def initialize(args = {})
    @element = args[:element]
    @old_primary_program_id = args[:old_primary_program_id]
    @old_secondary_program_id = args[:old_secondary_program_id]
  end

  def sync
    primary_program_changed if old_primary_program_id != element.primary_program_id
    secondary_program_changed if old_secondary_program_id != element.secondary_program_id
  end

  private

    def primary_program_changed
      create_documents_program(element.primary_program_id)
      delete_documents_program(old_primary_program_id) if old_primary_program_id
    end

    def secondary_program_changed
      create_documents_program(element.secondary_program_id)
      delete_documents_program(old_secondary_program_id) if old_secondary_program_id
    end

    def delete_documents_program(program_id)
      element.documents.each do |document|
        other_elements_with_program = document.elements.with_program_id(program_id).where.not(id: element.id)
        # delete documents_programs if there are no other elements that are using the join record
        document.documents_programs.where(program_id: program_id).destroy_all if other_elements_with_program.empty?
      end
    end

    def create_documents_program(program_id)
      element.documents.each do |document|
        documents_program = document.documents_programs.where(program_id: program_id).first
        next if documents_program.present?
        DocumentsProgram.create(document_id: document.id, program_id: program_id)
      end
    end

end
