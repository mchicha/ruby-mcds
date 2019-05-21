class AddOriginIdToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :origin_id, :integer

    Document.preload(parent: [source: :source], source: :source).find_each do |doc|
      current_doc = doc

      until doc.origin_id do

        if current_doc.has_parent?
          current_doc = current_doc.parent
        elsif current_doc.has_source?
          current_doc = current_doc.source
        else
          doc.origin_id = current_doc.id
          doc.save
        end
      end
    end
  end
end
