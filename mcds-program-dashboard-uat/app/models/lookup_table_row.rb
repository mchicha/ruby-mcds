class LookupTableRow < ActiveRecord::Base
  belongs_to :lookup_table

  validates :key, presence: true

  scope :active,           -> { where(archived: false) }
  scope :archived,         -> { where(archived: true) }
  scope :descending,       -> { order({archived: :asc, created_at: :desc}) }

  serialize :columns, JSON

  def active?
    !archived?
  end

end
