namespace :schematic_editor do

  desc "Set national geography for those with geo set to nil"
  task set_national: :environment do
    national = Geography.national
    Schematic.all.each do |schematic|
      next if schematic.geographies.any?
      puts "#{schematic.name} schematic has zero geographies..."
      schematic.geographies << national
      puts "Adding national to #{schematic.name} schematic"
      if schematic.save
        puts "success."
      else
        puts "not saved."
      end
    end
  end
end
