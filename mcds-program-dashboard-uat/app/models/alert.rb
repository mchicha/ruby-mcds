class Alert < ActiveRecord::Base
  belongs_to :alertable, polymorphic: true
  belongs_to :user
  has_many :alert_geographies
  has_many :geographies, through: :alert_geographies

  accepts_nested_attributes_for :geographies

  scope :for_today,     ->        { unarchived.for_day(Date.today) }

  scope :unarchived,    ->        { where(archived: false) }

  scope :for_day,       -> (day)  {
    self.where(
      self.arel_table[:remove_date].gteq(day).and(
        self.arel_table[:post_date].lteq(day)
      )
    )
  }

  scope :for_homepage,  -> (geog) {
    self.for_today.joins(
      :geographies
    ).where(
      Geography.arel_table[:id].eq(geog.id).or(
        Geography.arel_table[:id].eq(Geography.national.id).and(Alert.arel_table[:show_all].eq(true))
      )
    )
  }

  def status
    if self.archived
      'Archived'
    elsif self.active_today?
      'Current'
    elsif self.future_post?
      'Planned'
    elsif self.past_post?
      'Past'
    end
  end

  def national?
    national_geography = Geography.national
    if geographies.loaded?
      geographies.include?(national_geography)
    else
      geographies.where(id: national_geography.id).count > 0
    end
  end

  def is_displayed?
    unarchived? && active_today?
  end

  def unarchived?
    !archived
  end

  def active_today?
    active_on_day?(Date.current)
  end

  def active_on_day?(date)
    active_before_remove?(date) && active_after_post?(date)
  end

  def active_before_remove?(date)
    self.remove_date >= date
  end

  def active_after_post?(date)
    self.post_date <= date
  end

  def future_post?(date = Date.current)
    active_before_remove?(date) && !active_after_post?(date)
  end

  def past_post?(date = Date.current)
    !active_before_remove?(date) && active_after_post?(date)
  end
end
