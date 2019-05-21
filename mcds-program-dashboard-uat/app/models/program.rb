class Program < ActiveRecord::Base

  # ASSOCIATIONS
  belongs_to :user
  belongs_to :status
  belongs_to :delivery_method
  has_many :geography_program
  has_many :geographies, through: :geography_program
  has_and_belongs_to_many :date_ranges
  has_and_belongs_to_many :color_blocks
  has_many :resources, as: :resourceable

  has_many :documents_programs
  has_many :documents, through: :documents_programs
  has_many :schematics, through: :documents

  accepts_nested_attributes_for :resources, allow_destroy: true, reject_if: proc { |attr| %i[file].any?{|a| attr[a].blank? } }
  accepts_nested_attributes_for :date_ranges

  enum calendar_display: [:assigned_geographies, :all_geographies, :no_geographies]

  before_save :sanitize_html

  delegate :schematic, to: :document

  scope :for_requested_geographies, -> (geography_ids) { joins(:geographies).where(geographies: {id: geography_ids}) }

  BLANK_DEFAULTS = ["Element Name", "Position Ids", "Zone", "Size", "Depth", "Status", "Position Name"]

  # VALIDATIONS
  #TODO: Add validation to only allow 1 color_block_id to be assigned to a program
  validates :geography_program, :name, :delivery_method, presence: true
  auditable

  # SCOPES
  scope :for_user, -> (user_id) {
    where(:user_id => user_id) if user_id.present?
  }

  scope :for_specific_users, -> (user_ids) {
    where(:user_id => user_ids) if user_ids.present?
  }

  scope :for_specific_geographies, -> (geography_ids) {
    joins(:geographies).where(geographies: {id: geography_ids}) if geography_ids.present?
  }

  scope :for_specific_coops_and_national, -> (geography_ids) {
    return unless geography_ids.present?
    geography_ids = [geography_ids] unless geography_ids.is_a?(Array)

    geography = Geography.arel_table
    programs = Program.arel_table

    joins(:geographies).where(
      geography[:id].in(geography_ids).or(
        geography[:name].matches(Geography::NATIONAL_NAME)
      )
    )
  }

  scope :search_project, -> (search_field) {
    where("programs.name LIKE ?", "%#{search_field}%") if search_field.present?
  }

  scope :display_named_date_ranges, -> {
    where(date_ranges: {date_type_id: DateType.calendar_date_type_ids})
  }

  scope :date_ranges_for_types, -> (opts = {}) {
    return unless opts[:start_date]

    # If single input, alter to array
    opts[:date_types] = [opts[:date_type]] if opts[:date_type]

    # if not end date given, make it a day AFTER the start date so that the gap is one day
    unless opts[:end_date]
      if opts[:start_date].present? && (opts[:start_date].is_a?(String) || opts[:start_date].is_a?(DateTime))
        opts[:end_date] = opts[:start_date].to_date + 1
      else
        opts[:end_date] = opts[:start_date] + 1
      end
    end

    date_ranges_table = DateRange.arel_table
    date_types_table = DateType.arel_table

    joins(:date_ranges => :date_type).where(
      date_types_table[:name].in(opts[:date_types]).and(
        date_ranges_table[:end_date].between(opts[:start_date]..opts[:end_date]).or(
          date_ranges_table[:start_date].between(opts[:start_date]..opts[:end_date])
        )
      )
    )
  }

  scope :date_range_programs, -> (start_date = nil, end_date = nil) {
    return unless start_date

    unless end_date
      if start_date.present? && (start_date.is_a?(String) || start_date.is_a?(DateTime))
        end_date = start_date.to_date + 1
      else
        end_date = start_date + 1
      end
    end

    joins(:geographies).joins(:date_ranges)
    .where('date_ranges.start_date between ? and ?', start_date, end_date)
  }

  scope :for_event_category, -> (event_type_name){
    geo_type_id = GeographyType.find_by_name(event_type_name).try(:id)

    includes(:geographies). where(geographies: {geography_type_id: geo_type_id}) if geo_type_id
  }

  scope :for_specific_status, -> (program_status) {
    joins(:status).merge(Status.send(program_status))
  }

  scope :active_status, -> {
    joins(:status).merge(Status.active)
  }

  scope :non_archived, -> {
    joins(:status).where.not(statuses: {name: Status::Options::ARCHIVED})
  }



  # CLASS METHODS
  def self.filter_by_name_or_geography(keyword)
    geography = Geography.arel_table
    programs = Program.arel_table
    joins(:geographies).where(geography[:name].matches("%#{keyword}%").or(
      programs[:name].matches("%#{keyword}%")
    ))
  end

  def self.date_ranges_for_type(date1, date2, date_type_name)
    date_range = DateRange.arel_table
    joins(date_ranges: :date_type).where(
      date_range[:start_date].gteq(string_to_beginning_of_date(date1)).and(
        date_range[:start_date].lteq(string_to_end_of_date(date2))
      )
    ).where(date_types: {name: date_type_name})
  end

  def self.updated_at_range(date1, date2)
    where(updated_at: string_to_beginning_of_date(date1)..string_to_end_of_date(date2))
  end

  def self.associated_to_users_geographies(user)
    geography = Geography.arel_table
    joins(:geographies).where(geography[:name].eq('National').or(geography[:id].in(user.geographies.map(&:id)))).uniq
  end

  def self.for_single_day(start_date)
    joins(:geographies).joins(:date_ranges).
    where(date_ranges: {start_date: start_date}).
    group('programs.id, geographies.name').
    order('programs.id, geographies.name')
  end


  def self.for_calendar(opts = {})
    date_range_programs(opts[:start_date], opts[:end_date]).
    for_event_category(opts[:event_category]).
    for_user(opts[:user]).
    display_named_date_ranges.for_specific_geographies(opts[:coops]).
    search_project(opts[:search_field])
  end

  def self.for_given_month(opts = {})
    opts[:geography_ids] = [opts[:geography_ids]] unless opts[:geography_ids].is_a?(Array)

    geography_table = Geography.arel_table
    date_range_table = DateRange.arel_table

    displays = Program.calendar_displays

    Program.joins(
      :date_ranges
    ).joins(
      :geographies
    )
    .where(
      geography_table[:id].in(opts[:geography_ids]).and(
        Program.arel_table[:calendar_display].in([displays[:assigned_geographies], displays[:all_geographies]])
      ).or(
        # TO get national that are shown to all (if selected geog is national, the distinct below prevents any possible duplication of returns)
        geography_table[:id].in(Geography.national.id).and(
          Program.arel_table[:calendar_display].in([displays[:all_geographies]])
        )
      )
    )
    .where(
        date_range_table[:date_type_id].in(DateType.calendar_date_type_ids).and(
        date_range_table[:start_date].lt(opts[:end_of_month])
      ).and(
        date_range_table[:end_date].gt(opts[:start_of_month])
      )
    ).group(
      'programs.id, geographies.name'
    ).order(
      'programs.id, geographies.name'
    ).distinct
  end


  # INSTANCE METHODS
  #TODO: See if there is a better way to handle this
  def date_range_for_type(date_type)
    date_ranges.joins(:date_type).where(date_type: date_type).first || nil
  end

  def dam_assets
    @dam_assets ||= (
      assets = DamAsset.new.retrieve_assets["assets"]
      assets = [] if assets.nil? || assets.is_a?(String)

      program_assets = assets.collect{|asset|
        asset if asset["metadata"].find{|meta|
          meta if meta["name"] == "Program ID" && meta["value"] == id.to_s
        }
      }.compact
      program_assets
    )
  end

  def get_thumb_nail_image(refresh=false)
    if self.thumb_image_url.blank? || false
      ThumbUrlWorker.perform_async(self.id)
    end

    self.thumb_image_url || 'http://placehold.it/225x225'
  end

  def is_national?
    geographies.first.geography_type_id.nil?
  end

  def info_for_dam
    upper = date_ranges.where(date_type: (DateType.where(name: 'pop_install'))).first
    upper = upper.start_date.strftime('%-m/%-d/%Y') if upper

    downer = date_ranges.where(date_type: (DateType.where(name: 'pop_take_down'))).first
    downer = downer.start_date.strftime('%-m/%-d/%Y') if downer
    {'Program ID' => id, 'Program Name' => name, 'National Job Number' => number,
      'Market Category' => color_blocks.first.try(:name), 'Up Date' => upper, 'Down Date' => downer }
  end

  def default_info_for_dam
    program_details = info_for_dam
    BLANK_DEFAULTS.map {|x| program_details[x] = ""}
    program_details
  end

  def self.date_range_programs(start_date, end_date)
    joins(:geographies).joins(:date_ranges).
    where('date_ranges.start_date between ? and ?', start_date, end_date)
  end

  def self.for_user(user)
    where("'#{user}' = 'all' or user_id = ?", user)
  end

  def self.search_project(search_field)
    where("programs.name LIKE ?", "%#{search_field}%")
  end

  def non_query_kit_delivery_dates
    # Client requested Kit Delivery to be taken off homepage but this method left for when they change their minds
    self.date_ranges.select{|date_range| date_range.date_type.try(:name) == 'kit_delivery_between'}
  end

  def non_query_pop_install_date_range
    # This is when date_ranges are preloaded, it blocks a new query
    self.date_ranges.detect{|date_range| date_range.date_type.try(:name) == 'pop_install'}
  end

private

  def self.string_to_beginning_of_date(date_string)
    convert_string_to_date(date_string).at_midnight
  end

  def self.string_to_end_of_date(date_string)
    convert_string_to_date(date_string).at_end_of_day
  end

  def self.convert_string_to_date(date)
    begin
      Date.strptime(date, "%m/%d/%Y")
    rescue
      Date.today
    end
  end

  def sanitize_html
    notes_body = self.notes
    if notes_body
      notes_body.gsub!(/(<)(script[\s\S]*?)(>)/, '&lt\2&gt')
      notes_body.gsub!(/(<)(\/script[\s\S]*?)(>)/, '&lt\2&gt')
      notes_body.gsub!(/(<)(iframe[\s\S]*?)(>)/, '&lt\2&gt')
    end

    pos_body = self.pos
    if pos_body
      pos_body.gsub!(/>/, '&gt')
      pos_body.gsub!(/</, '&lt')
    end


    # notes_body
    self.notes = notes_body
    self.pos = pos_body
  end

end
