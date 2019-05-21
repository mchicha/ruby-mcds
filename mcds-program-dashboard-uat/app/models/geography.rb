class Geography < ActiveRecord::Base

  NATIONAL_NAME = "National"

  # has_and_belongs_to_many :programs
  has_many :geography_program
  has_many :programs, through: :geography_program
  has_many :geography_users
  has_many :users, through: :geography_users
  has_many :coop_schematics, class_name: 'Schematic'
  has_many :geography_messages
  has_many :messages, through: :geography_messages
  has_many :geographies_schematics
  has_many :schematics, through: :geographies_schematics
  has_many :document_schematics
  has_many :document_elements
  has_and_belongs_to_many :agencies

  has_many :alert_geographies
  has_many :alerts, through: :alert_geographies

  has_many :geography_moments
  has_many :moments, through: :geography_moments

  belongs_to :geography_type

  has_ancestry cache_depth: true

  scope :except_national,   -> { where.not(name: NATIONAL_NAME) }
  scope :national,          -> { where(name: NATIONAL_NAME).first }
  scope :co_ops,            -> { joins(:geography_type).where(geography_types: {name: "COOP"}) }

  scope :national_and_coops, -> {
    geog_table = Geography.arel_table
    geog_type_table = GeographyType.arel_table
    outer_join = Arel::Nodes::OuterJoin

    Geography.where(
      geog_table[:name].eq(Geography::NATIONAL_NAME).or(
        geog_type_table[:name].eq("COOP")
      )
    ).joins(
      geog_table.join(
        geog_type_table, outer_join
      ).on(
        geog_table[:geography_type_id].eq(
          geog_type_table[:id]
        )
      ).join_sources
    ).order(geog_table[:coop_id])
  }

  scope :menu_geographies, -> (user) {
    return if user.admin_or_super_admin?
    geog_table = Geography.arel_table
    geog_type_table = GeographyType.arel_table
    user_table = User.arel_table
    geog_user_table = GeographyUser.arel_table
    outer_join = Arel::Nodes::OuterJoin

    Geography.where(
      geog_table[:name].not_eq(Geography::NATIONAL_NAME).and(
        geog_type_table[:name].not_eq("COOP")
      ).or(
        user_table[:id].eq(user.id)
      )
    ).joins(
      geog_table.join(
        geog_type_table, outer_join
      ).on(
        geog_table[:geography_type_id].eq(
          geog_type_table[:id]
        )
      ).join_sources
    ).joins(
      geog_table.join(
        geog_user_table, outer_join
      ).on(
        geog_user_table[:geography_id].eq(
          geog_table[:id]
        )
      ).join_sources
    ).joins(
      geog_user_table.join(
        user_table, outer_join
      ).on(
        geog_user_table[:user_id].eq(
          user_table[:id]
        )
      ).join_sources
    )
  }

  def self.geographies_for_user_dropdown(given_user)
    if given_user.admin_or_super_admin?
      national_and_coops
    else
      given_user.geographies
    end
  end

  def is_a_co_op?
    national? || (geography_type && geography_type.name == "COOP")
  end

  def national?
    name == NATIONAL_NAME
  end

end
