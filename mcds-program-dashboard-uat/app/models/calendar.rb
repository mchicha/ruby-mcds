class Calendar < ActiveRecord::Base
  belongs_to :user

  def calendar_grid_programs(user, start_date, end_date, coops)
    Program.for_calendar(
      user: user,
      start_date: start_date,
      end_date: end_date,
      coops: coops
    )
  end

  def calendar_grid_messages(user, start_date, end_date, coops)
    Message.for_calendar(
      user: user,
      start_date: start_date,
      end_date: end_date,
      coops: coops,
    )
  end

end
