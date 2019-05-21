# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Geography.find_or_create_by(name: "National")

# # Statuses
# Status.find_or_create_by(name: "Current")
# Status.find_or_create_by(name: "Archived")
# Status.find_or_create_by(name: "Planning")

# # Delivery Methods
# DeliveryMethod.find_or_create_by(name: "UPS")
# DeliveryMethod.find_or_create_by(name: "Distribution Center")

# User.find_or_create_by(email: "e.agnew@tukaiz.com", cas_user_id: 2591)
# User.find_or_create_by(email: 'm.ishikawa@tukaiz.com', cas_user_id: 32)
# User.find_or_create_by(email: "a.tobiasiewicz@tukaiz.com", cas_user_id: 2813)
# User.find_or_create_by(email: "p.cosentino@tukaiz.com", cas_user_id: 23)
# User.find_or_create_by(email: "j.chestang@tukaiz.com", cas_user_id: 2787)
# User.find_or_create_by(email: "b.patterson@tukaiz.com", cas_user_id: 94)
# User.find_or_create_by(email: "c.soler-rodriguez@tukaiz.com", cas_user_id: 90)

friendly_sheet = File.open("#{Rails.root}/spec/fixtures/import_spreadsheets/CP_Template_and_Friendly_Names_8-11-15.xlsx")

position_sheets = File.open("#{Rails.root}/spec/fixtures/import_spreadsheets/McSource_Online_Position_Labels.xlsx")


LookupTable.import_spreadsheet(spreadsheet: friendly_sheet, table_name: 'friendly', key_field_name: 'Template Name')
LookupTable.import_spreadsheet(spreadsheet: position_sheets, table_name: 'position', key_field_name: 'Template Name')
