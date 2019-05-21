class Status < ActiveRecord::Base
  has_many :programs

  module Options
    ARCHIVED = 'Archived'
    PUBLISHED = 'Published'
    PLANNING = 'Planning'
  end

  scope :active, -> {
    where.not(name: Options::ARCHIVED)
  }

  scope :archived, -> {
    where(name: Options::ARCHIVED)
  }

  scope :planning, -> {
    where(name: Options::PLANNING)
  }

  scope :published, -> {
    where(name: Options::PUBLISHED)
  }

  def self.archive_id
    find_by_name(Options::ARCHIVED).id
  end

  def self.published_id
    find_by_name(Options::PUBLISHED).id
  end

  def self.planning_id
    find_by_name(Options::PLANNING).id
  end

  def archived?
    name == Options::ARCHIVED
  end

  def published?
    name == Options::PUBLISHED
  end

  def planning?
    name == Options::PLANNING
  end

  def active?
    name == Options::PUBLISHED || Options::PLANNING
  end

end
