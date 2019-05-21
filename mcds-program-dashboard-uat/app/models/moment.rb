class Moment < ActiveRecord::Base
  belongs_to :momentable, polymorphic: true
  belongs_to :user
  has_many :geography_moments
  has_many :geographies, through: :geography_moments

  accepts_nested_attributes_for :geographies

  scope :unarchived,    ->        { where(archived: false) }

  scope :for_day,       -> (day)  {
    self.where(
      self.arel_table[:remove_date].gteq(day).and(
        self.arel_table[:post_date].lteq(day)
      )
    )
  }

  def self.for_given_month(opts = {})
    opts[:geography_ids] = [opts[:geography_ids]] unless opts[:geography_ids].is_a?(Array)

    moment_table = Moment.arel_table
    geography_table = Geography.arel_table

    Moment.unarchived.joins(
      :geographies
    )
    .where(
      geography_table[:id].in(opts[:geography_ids]).or(
        geography_table[:id].eq(Geography.national.id).and(moment_table[:show_all].eq(true))
      )
    ).where(
      moment_table[:post_date].lteq(opts[:end_of_month]).and(
        moment_table[:remove_date].gteq(opts[:start_of_month])
      )
    ).group(
      moment_table[:id], geography_table[:name]
    ).order(
      moment_table[:id], geography_table[:name]
    )
  end


  # def shown_to_all?
  #   # currently this ignores the archived flag, added :unarchived? if that is needed
  #   national?
  # end

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
