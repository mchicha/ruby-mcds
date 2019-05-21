class AddMissingIndexes < ActiveRecord::Migration
  def change

    [
      [:messages, :user_id],

      [:message_users, :user_id],
      [:message_users, :message_id],

      [:programs, :delivery_method_id],
      [:programs, :status_id],
      [:programs, :user_id],

      [:schematics, :parent_id],
      [:schematics, :source_id],
      [:schematics, :epic_id],
      [:schematics, :last_modified_by_id],

      [:documents, :parent_id],
      [:documents, :source_id],
      [:documents, :zone_id],

      [:documents_programs, :document_id],
      [:documents_programs, :program_id],
      [:documents_programs, :element_id],

      [:document_elements, :document_id],
      [:document_elements, :element_id],

      [:document_schematics, :document_id],
      [:document_schematics, :schematic_id],
      [:document_schematics, :element_id],


      [:date_ranges, :date_type_id],

      [:agencies_users, :agency_id],
      [:agencies_users, :user_id],

      [:calendars, :user_id],

      [:color_blocks_programs, :program_id],
      [:color_blocks_programs, :color_block_id],

      [:contact_list_messages, :message_id],
      [:contact_list_messages, :contact_list_id],

      [:contact_list_messages, :message_id],
      [:contact_list_messages, :contact_list_id],

      [:contact_lists, :user_id],

      [:geography_messages, :message_id],
      [:geography_messages, :geography_id],

      [:geographies, :geography_type_id],

      [:images, :schematic_id],
      [:images, :document_id],

      [:lookup_table_rows, :lookup_table_id],

      [:epics, :origin_id],
      [:epics, :template_id]
    ].each do |table, column|

      begin
        add_index table, column, using: :btree
      rescue
        # If index already exists, we just rescue and go about our business.
      end

    end

  end
end
