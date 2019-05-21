class DocumentsController < ApplicationController
  before_action :require_user
  before_action :modify_origin_document_check
  load_and_authorize_resource

  def index
    @documents = @documents.where(origin_id: nil, parent_id: nil, type_of: 'template_page').order(sort_order: :asc)
  end

  def edit

  end

  def update
    @document.update_attributes(document_params)
    Document.where(origin_id: @document.id).update_all(display_name: @document.display_name, sort_order: @document.sort_order)

    redirect_to documents_path
  end

  def rejoin_programs
    DocumentRejoinProgramsWorker.perform_async

    redirect_to documents_path
  end

  private

  def document_params
    params.require(:document).permit(
      :display_name, :sort_order
    )
  end

  def modify_origin_document_check
    authorize! :manage, :origin_documents
  end
end
