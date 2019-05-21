class Schematic < ActiveRecord::Base

  belongs_to  :epic
  belongs_to  :last_modified_by, class_name: 'User', foreign_key: :last_modified_by_id
  belongs_to  :source, class_name: 'Schematic'
  belongs_to  :parent, class_name: 'Schematic'
  has_many    :children, class_name: 'Schematic', foreign_key: :parent_id, dependent: :destroy
  has_many    :document_schematics, dependent: :destroy
  has_many    :documents, through: :document_schematics
  has_many    :notes, through: :documents
  has_many    :document_elements, through: :documents
  has_many    :elements, through: :document_elements
  has_many    :images, through: :documents
  has_many    :geographies_schematics
  has_many    :geographies, through: :geographies_schematics
  has_many    :agencies, -> { uniq }, through: :geographies
  has_many    :users, through: :geographies
  has_many    :clones, class_name: 'Schematic', foreign_key: :source_id
  has_many    :documents_programs, through: :documents
  has_many    :programs, through: :documents_programs
  has_many    :images

  default_scope { where.not(status: nil).order(id: :desc) }

  scope :for_requested_geographies, -> (geography_ids) { joins(:geographies).where(geographies: {id: geography_ids}) }
  scope :active_planning,           -> { planning.non_archived}
  scope :active_published,          -> { published.non_archived}
  scope :non_archived,              -> { where(Schematic.arel_table[:end_date].gt(Date.today)) }
  scope :archived,                  -> { where(Schematic.arel_table[:end_date].lteq(Date.today)) }

  scope :by_status, -> (statuses) {
    status_queries = self.sanitize_statuses(statuses)
    return Schematic.none unless status_queries.present?

    Schematic.where(
      status_queries.inject(&:or)
    ).distinct
  }

  scope :for_date_range, -> (opts = {}) {
    return unless opts[:attribute] && (opts[:from] || opts[:to])
    Schematic.where(self.date_range_query(opts))
  }


  enum status:  [:planning, :published]
  enum sch_type:[:standard, :test, :template]

  validates :name, presence: true

  before_save   :propogate_changes_to_children
  after_create  :build_schematic
  # PDF generation is on pause, so the next line is commented out. Uncomment to resume
  # after_commit  :queue_render


  ##################
  # Schematic Index page display logic, based on roles and assigned goegraphies
  ################

  def self.index_for_selected_geographies(opts = {})
    if opts[:geography_ids].include?(Geography.national.id)
      self.national_index(opts)
    else
      self.non_national_index(opts)
    end
  end

  def self.national_index(opts = {})
    # Not actually just National Schematics, all parent schematics (so including multi-coop assigned schematics)
    stats_query = self.status_condition_for_national_geog(opts[:user]) # Visible National Schematic Statuses per user role
    self.where(parent_id: nil).where(stats_query)
  end

  def self.non_national_index(opts)
    if opts[:user].admin_or_super_admin? || (opts[:user].inputter_assigned_to_geography_ids?(opts[:geography_ids]))
      # Admins and assigned inputters get the fancy complex query
      self.admin_index_for_selected_geographies(opts)
    else
      # Unassigned inputters, leadership, and read-only get just published CHILD schematics, archived or not
      for_requested_geographies(opts[:geography_ids]).where.not(parent_id: nil).published
    end
  end

  def self.admin_index_for_selected_geographies(opts = {})
    # TLDR: All child schematics for the selected geog, only parent schematics without a child assigned to the selected geog
    # Expanded:
      # Schematics:
        # All assigned child schematics are pulled in. National schematics and selected parent schematics assigned to the geography
        # are pulled in only if the do not have a child already assigned to the geography. So once a Coop version is made, it should
        # no longer appear in the query for that index page
      # Roles And Statuses:
        # Both Admin-roles can see all
        # Inputters can see published national schematics

    # Return parent ids of schematics attached to the selected geography
    arel_parent_id_query = parent_ids_already_with_children_query(opts)
    sub_query = Arel.sql("(#{arel_parent_id_query})") # Arel doesn't play nice with subqueries, so we save it as a string then pass it in below

    # The Actual Query
    Schematic.where(
      GeographiesSchematic.arel_table[:geography_id].in(
        # Grab joined to selected geography
        opts[:geography_ids]
      ).and(
        # Grab ALL children (no parent_id)
        Schematic.arel_table[:parent_id].not_eq(nil).
        or(
          # Status condition for parents attached to geography (selected nationals)
          status_condition_for_national_geog(opts[:user])
        )
      )
      .or(
        # grab national schematics
        GeographiesSchematic.arel_table[:geography_id].eq(Geography.national.id).and(
          # check what national status users should be seeing based on role
          status_condition_for_national_geog(opts[:user])
        )
      ).and(
        # disqualify any schematics with a child already attached to this geography (subquery from above)
        Schematic.arel_table[:id].not_in(sub_query)
      )
    ).group(
      # Prevent duplicate returns
      Schematic.arel_table[:id]
    ).joins(
      Schematic.arel_table.join(GeographiesSchematic.arel_table).on(
        Schematic.arel_table[:id].eq(GeographiesSchematic.arel_table[:schematic_id])
      ).join_sources
    )
  end

  def self.parent_ids_already_with_children_query(opts = {})
    # Get parent ids of all schematics for selected geography ids
    Schematic.select(Schematic.arel_table[:parent_id]).where(
      Schematic.arel_table[:parent_id].not_eq(nil).and(
        GeographiesSchematic.arel_table[:geography_id].in(opts[:geography_ids])
      )
    ).joins(
      Schematic.arel_table.join(GeographiesSchematic.arel_table).on(
        Schematic.arel_table[:id].eq(GeographiesSchematic.arel_table[:schematic_id])
      ).join_sources
    ).to_sql
  end

  def self.status_condition_for_national_geog(user)
    # For National Schematics...Admins can see all statuses, others can only see published
    if user.try(:admin_or_super_admin?)
      Schematic.arel_table[:status].not_eq(nil)
    else
      Schematic.arel_table[:status].eq(1)
    end
  end

  # Date Range filter query on browse-index
  def self.date_range_query(opts = {})
    attrib = Schematic.arel_table[opts[:attribute]]
    from = attrib.gteq(opts[:from]) if opts[:from]
    to = attrib.lteq(opts[:to]) if opts[:to]

    if to && from
      from.and(to)
    else
      from || to
    end
  end


  ##################
  # INSTANCE METHODS:
  ################

  def geography_ids
    geographies.pluck(:id)
  end

  def build_document(parent_document)
    document_hash = {'parent_id' => parent_document.id}

    if parent_id.nil?
      # if schematic is a parent, then documents are clones not children

      ####### THIS IS BAD #########
      # The parent document might be the origin as shown down on 194. This sets it to be the source id automatically
      # This needs to be fixed but is being put off due to fears of breaking other parts of the code
      document_hash = {'source_id' => parent_document.id}
      ############################

    elsif has_source?
      # if source is given, they share parents
      document_hash['source_id'] = document_hash['parent_id']
      document_hash['parent_id'] = parent_document.parent_id
    end

    if parent_document.origin_id.present?
      document_hash['origin_id'] = parent_document.origin_id
    elsif ['template_page', 'template_layout'].include?(parent_document.type_of)
      document_hash['origin_id'] = parent_document.id
    end

    document = documents.build(get_object_attrs(parent_document).merge(document_hash))

    if document.save
      self.documents << document


      # ##################
      # Layout Cousin Check:
      # ################

      backward_looking_layout_info = {cousin_layout: nil, replace: nil}

      if parent_id.present? && parent_document.source_id.present? && document.type_of == 'layout'
        partial_replace_layouts = [
          {filename: "Drive Thru Zone/Drive Thru Zone - FP43/Container_16.10/Schematic_dthru_16.35_Full.svg", height: "546.4"},
          {filename: "Drive Thru Zone/Drive Thru Zone - FP43/Container_16.10/Schematic_dthru_16.10_Full_Container.svg", height: "546.4"},
          {filename: "Drive Thru Zone/Drive Thru Zone - FP43/Container_16.15/Schematic_dthru_16.51_2Third_bottom.svg", height: "519.88"},
          {filename: "Drive Thru Zone/Drive Thru Zone - FP43/Container_16.18/Schematic_dthru_16.54_2Third_bottom.svg", height: "519.88"},
          {filename: "Drive Thru Zone/Drive Thru Zone - OPO Breakfast/Container_17.2/Schematic_dthru_OPO_17.42_Full.svg", height: "576"},
          {filename: "Drive Thru Zone/Drive Thru Zone - OPO Breakfast/Container_17.2/Schematic_dthru_OPO_17.2_Full_Container.svg", height: "576"},
          {filename: "Drive Thru Zone/Drive Thru Zone - OPO Lunch:Dinner/Container_18.2/Schematic_dthru_OPO_18.58_2Third_Bottom.svg", height: "548.887"},
          {filename: "Drive Thru Zone/Drive Thru Zone - OPO Lunch:Dinner/Container_18.5/Schematic_dthru_OPO_18.61_2Third_Bottom.svg", height: "548.887"},
          {filename: "Drive Thru Zone/Drive Thru Zone - FP43 COD/Container_19.15/Schematic_dthru_19.63_Full_Container.svg", height: "787.22"},
          {filename: "Drive Thru Zone/Drive Thru Zone - FP43 COD/Container_19.15/Schematic_dthru_19.15_Full_Container.svg", height: "787.22"},
          {filename: "Drive Thru Zone/Drive Thru Zone - FP43 COD/Container_19.10/Schematic_dthru_19.10_Full_Container.svg", height: "546.396"},
          {filename: "Drive Thru Zone/Drive Thru Zone - FP43 COD/Container_19.10/Schematic_dthru_19.35_Full.svg", height: "546.396"}
        ]

        if found_doc_info = partial_replace_layouts.detect{|doc_hash| doc_hash[:filename] == document.filename}
          backward_looking_layout_info[:cousin_layout] = parent_document.source.children.joins(schematics: :geographies).where(geographies: {id: self.geographies.first.id}).first
          backward_looking_layout_info[:replace] = {height: found_doc_info[:height]}
        end
      end


      # ##################
      # Build elements:
      # ################
      parent_document.elements.each do |e|

        element_hash = {'parent_id' => e.id}
        if parent_id.nil?
          element_hash = {'source_id' => e.id}
          if e.primary_dam_asset_id.present? || e.secondary_dam_asset_id.present?
            element_hash['grayscale'] = true
          end
        elsif has_source?
          # if source is given, they share parents
          element_hash['source_id'] = element_hash['parent_id']
          element_hash['parent_id'] = e.parent_id
        end

        ##########
        # Previous coop same geography overrirde.
        # If parent's source has a child with same geography, some get overrides from the 'cousin'
        if parent_id.present?

          if e.values.present?
            # EVM and BVM are coop specific, so we need them from the previous month until merge conflict is created
            backwards_cousin_looking_position_ids = ['EVM_Full_Shape', 'BVM_Full_Shape', '10.24', '10.25', '10.29', '10.30']

            # It is nil to begin, but is assigned below if found so that on second of these ids we use the cache instead of getting a new one
            cousin_document = nil

            if backward_looking_layout_info[:cousin_layout].present?
              if backward_looking_layout_info[:replace][:height]
                if e.values['height'] == backward_looking_layout_info[:replace][:height]

                  cousin_element = backward_looking_layout_info[:cousin_layout].elements.where(Element.arel_table[:values].matches('%"height\":\"' + backward_looking_layout_info[:replace][:height] + '"%')).first

                  if cousin_element

                    element_hash.merge!(
                      {
                       'values' => cousin_element.values,
                       'primary_dam_asset_id' => cousin_element.primary_dam_asset_id,
                       'primary_dam_asset_path' => cousin_element.primary_dam_asset_path,
                       'grayscale' => true
                      }
                    )
                  end
                end
              end
            end

            # Iterate through the special position ids and check if this element has one of the position ids
            backwards_cousin_looking_position_ids.each do |pos_id|
              if e.values['id'] == pos_id
                # If nil, do the query, else just use the stored one
                cousin_document ||= parent_document.source.children.joins(schematics: :geographies).where(geographies: {id: self.geographies.first.id}).first

                if cousin_document
                  # If doc, find the element with the same position id. Note this WILL NOT WORK if cousin doc has same position ids on multiple elements
                  cousin_element = cousin_document.elements.where(Element.arel_table[:values].matches('%"' + pos_id + '"%')).first

                  # If found, through relevant values into the element_hash which overrides the element copy attrs below
                  if cousin_element
                    element_hash.merge!(
                      {'values' => cousin_element.values,
                       'primary_dam_asset_id' => cousin_element.primary_dam_asset_id,
                       'primary_dam_asset_path' => cousin_element.primary_dam_asset_path,
                       'grayscale' => true
                     }
                    )
                  end
                end
              end
            end
          end
        end

        element = document.elements.build(get_object_attrs(e).merge(element_hash))

        if element.save
          document.elements << element
        end
      end

      # All layout_id having elements do not know what their new layout_id will be on their creation...the new layout doesn't exist yet
      # So we here go back and find them all and update them appropriately after the fact
      # NOTE: This is why important that pages are processed BEFORE layouts
      if document.type_of == 'layout'
        queried_layout_id = parent_document.id

        if queried_layout_id
          self.elements.where(layout_id: queried_layout_id).update_all(layout_id: document.id)
        end
      end

      # ##################
      # Build notes:
      # ################
      parent_document.notes.each do |n|
        note_hash = {parent_id: n.id, name: DateTime.now.strftime('%Q')}
        attrs = n.attributes.except('id', 'created_at', 'updated_at')
        attrs.merge!(note_hash)

        if parent_id.nil?
          attrs[:source_id] = n.id
          attrs.delete('parent_id')
        elsif has_source?
          # if source is given, they share parents
          attrs[:source_id] = attrs[:parent_id]
          attrs[:parent_id] = n.parent_id
        end

        note = document.notes.build(attrs)

        if note.save
          document.notes << note
        end
      end
    end

    # ##################
    # link programs from copied elements
    # ################
    document.rejoin_programs

    document
  end


  def test?
    (sch_type || "").to_s === "test"
  end

  def propogate_changes_to_children
    return if self.archived? # Stop the process if the schematic is archived
    old_attrs = child_change_attributes(changed_attributes)

    return unless old_attrs.present?

    self.children.each do |child|
      child.parent_change_check(old_attributes: old_attrs, new_attributes: self.child_change_attributes)
    end
  end

  def child_change_attributes(attrs = self.attributes)
    attrs.slice('name', 'release_date', 'end_date')
  end

  def parent_change_check(opts = {})
    update_hash = {}
    opts[:old_attributes].each do |key, value|
      if self.attributes[key] == value
        update_hash[key] = opts[:new_attributes][key]
      end
    end

    if update_hash.present?
      self.update_attributes(update_hash)
    end
  end

  def queue_render
    PdfWorker.perform_in(50, self.id)
  end

  def generate_pdf
    WickedPdf.new.pdf_from_url(
      DAM_CONFIG[:uri_class].build(
      {
        host: ENV['HOST'],
        path: "/schematics/print/#{self.id}"
      }).to_s
      # ,
      # {
      #   cookie: "_mcds-program-dasboard_session #{ENV['COOKIE_JAR']}"
      # }
    )
  end

  def render_pdf
    if schematic_dam_asset_ids.any?
      pdf = generate_pdf
      begin
        file = Tempfile.new(['schematic-print-', '.pdf'])
        file.binmode
        file << pdf

        image = self.images.build(image: file)
        image.save!
      ensure
         file.close
         file.unlink   # deletes the temp file
      end

      image
    end
  end

  def archived?
    if parent_id
      parent.try(:archived?)
    else
      (self.try(:end_date) || Date.today) <= Date.today
    end
  end

  def self.child_ids_of_archived_parents_subquery
    sub_query = self.select(:id).where(parent_id: nil).archived.to_sql
    Arel.sql("(#{sub_query})")
  end

  def self.parsed_status_query(given_status)
    schematic_table = Schematic.arel_table
    # for parents
    schematic_table[:parent_id].eq(nil).and(schematic_table[:status].eq(given_status)).and(schematic_table[:end_date].gt(Date.today)).or(
      # for children
      schematic_table[:parent_id].not_eq(nil).and(schematic_table[:status].eq(given_status)).and(schematic_table[:parent_id].not_in(child_ids_of_archived_parents_subquery))
    )
  end

  def self.sanitize_statuses(statuses)
    statuses = [statuses] unless statuses.is_a?(Array)
    statuses = statuses.uniq

    parsed_statuses = []

    schematic_table = Schematic.arel_table

    if statuses_array_include?(statuses, [0, '0', 'planning', :planning])
      parsed_statuses << self.parsed_status_query(0)
    end

    if statuses_array_include?(statuses, [1, '1', 'published', :published])
      parsed_statuses << self.parsed_status_query(1)
    end

    if statuses_array_include?(statuses, [2, '2', 'archived', :archived])
      # parsed_statuses << schematic_table[:end_date].lteq(Date.today)
      parsed_statuses << (
        # for parents
        schematic_table[:parent_id].eq(nil).and(schematic_table[:end_date].lteq(Date.today)).or(
          # for children
          schematic_table[:parent_id].not_eq(nil).and(schematic_table[:parent_id].in(child_ids_of_archived_parents_subquery))
        )
      )
    end

    parsed_statuses
  end

  def self.statuses_array_include?(statuses, possibles)
    (statuses - possibles).length != statuses.length
  end

  def non_query_programs_for_geography(filter_geography)
    # Use this if programs are preloaded. Using scope after preload requeries. Do not use unless need to

    programs.uniq.select do |prog|
       prog.date_ranges.detect{|dr| dr.date_type.try(:name) == "pop_install" && dr.end_date >= self.release_date && dr.start_date <= self.end_date} && prog.geography_program.detect{|geog_prog| geog_prog.geography_id == filter_geography.try(:id)}
    end
  end

  private
    def has_source?
      self.source_id.present?
    end

    def build_schematic
      source_schematic = has_source? ? get_schematic(source_id) : get_schematic(self.parent_id)

      if self.id != 1
        layout_ids = []

        # PROCESS ALL DOCUMENTS ON TEMPLATE
        source_schematic.documents.order(:type_of).preload(:notes, :elements).each do |d|
          # Skip layouts not connected to a current elements. We don't need unused ones copied
          if ['template_layout','layout'].include?(d.type_of) && !layout_ids.include?(d.id)
            next
          end

          build_document(d)

          if ['template_page','page'].include?(d.type_of)
            # Add any layout ids into the layout_ids array, so we kn
            layout_ids += d.elements.where.not(layout_id: nil).pluck(:layout_id)
          end
        end
      end
    end

    def get_schematic(schematic_id=nil)
      Schematic.unscoped.where(id: (schematic_id || 1) ).includes([
                                                                  :documents,
                                                                  :elements
        ]).first
    end

    def get_object_attrs(obj)
      obj = obj.attributes.except(
        'id',
        'created_at',
        'updated_at',
        'element_id',
        'modified',
        'document_id',
        'schematic_id'
      )

      set_type_of(obj)
    end

    def set_type_of(obj)
      if obj['type_of'].to_i < 3
        obj['type_of'] += 3
      end

      obj
    end

    def schematic_dam_asset_ids
      element_at = Element.arel_table
      self.elements.where(
        element_at[:primary_dam_asset_id].
        not_eq(nil).or(element_at[:secondary_dam_asset_id].not_eq(nil))).
        pluck(:primary_dam_asset_id, :secondary_dam_asset_id).flatten.compact
    end

end
