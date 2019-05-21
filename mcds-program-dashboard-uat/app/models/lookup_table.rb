class LookupTable < ActiveRecord::Base
  extend LookupTableImporter

  has_many :lookup_table_rows

  validates :key_field_name, presence: true

  scope :active,           -> { where(archived: false) }
  scope :archived,         -> { where(archived: true) }
  scope :descending,       -> { order({archived: :asc, created_at: :desc}) }


  # --For getting information from table rows
  def self.get_template_name_by_key(key)
    # this is set up as shorthand because we are currently only using the follow options, the rest of the code is available in case
    self.merge_table_rows_for_key('Template Name', ['friendly', 'position'], key)
  end

  def self.merge_table_rows_for_key(field, table_names, key)
    tables = self.get_tables_from_names(field, table_names)
    self.get_table_rows_for_key(tables, key)
  end

  def self.get_table_rows_for_key(tables, key)
    tables.inject({}) do |memo, table|
      rows = table.lookup_table_rows.where(key: key).descending.first
      if rows
        cols = rows.columns

        if cols['Position Ids']
          cols['Position Ids'] = cols['Position Ids'].join(',')
        end

        memo.merge!(rows.columns)
      end
      memo
    end
  end

  def self.get_tables_from_names(field_name, names)
    names.map do |name|
      table = self.most_recent_table_by_table_name(field_name, name)
      table.present? ? table : (raise "no table with table_name #{name} found!")
    end
  end

  def self.most_recent_table_by_table_name(field_name, name)
    self.where(key_field_name: field_name, table_name: name).descending.first
  end


  # --For checking for key differences in the most current and second to most current versions
  def self.detect_key_changes(field, names)
    new_tables = []
    old_tables = []
    #created updated remove duplicated
    names.each do |tab_name|
      sorted = self.where(key_field_name: field, table_name: tab_name).descending
      new_tables << sorted.first
      old_tables << sorted[1]
    end
    raise 'new and old tables do not match' if new_tables.length != old_tables.length

    new_data = merge_tables(new_tables)
    old_data = merge_tables(old_tables)

    total_keys = new_data.keys && old_data.keys

    total_keys.inject({}) do |memo, row_key|
      new_row = new_data[row_key]
      old_row = old_data[row_key]

      if (new_row != old_row) && new_row
        memo[row_key] = new_row
      end
      memo
    end
  end

  def self.merge_tables(tables)
    tables.inject({}) do |memo, table|
      table.lookup_table_rows.each do |row|
        memo[row.key] ||= {}
        cols = row.columns

        if cols['Position Ids']
          cols['Position Ids'] = cols['Position Ids'].join(',')
        end

        memo[row.key].merge!(row.columns)
      end
      memo
    end
  end

  # --Return hash of most recent tables to send to the DAM

  def self.merge_most_recent_tables(field, tables)
    records = tables.map{|table| self.most_recent_table_by_table_name(field, table)}
    self.merge_tables(records)
  end

  # --Detected Manually updated keys on most recent tables
  def self.detect_manual_updates(field_name, names)
    current_tables = get_tables_from_names(field_name, names)
    merged = merge_tables(current_tables)

    merged.keys.inject({}) do |memo, row_key|
      current_tables.each do |table|
        record = table.lookup_table_rows.find_by(key: row_key)

        if record && record.created_at != record.updated_at
          memo[row_key] = record.columns
          break
        end
      end
      memo
    end
  end

  # --Instance Methods:
  def active?
    !archived?
  end

end
