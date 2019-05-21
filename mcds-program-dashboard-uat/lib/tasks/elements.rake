namespace :elements do
  task set_program_ids: :environment do
    assets = DamAsset.new.retrieve_assets["assets"].group_by {|asset| asset["id"] }

    Element.where("primary_dam_asset_id IS NOT NULL").find_each do |element|
      puts "trying element ID #{element.id}"
      asset = assets[element.primary_dam_asset_id].try(:first)
      next unless asset
      program_meta = asset["metadata"].detect {|meta| meta["name"] == "Program ID" }
      element.primary_program_id = program_meta["value"]
      if element.save
        puts "succeeded saving element: #{element.id}"
      else
        puts "error saving element: #{element.id} ...#{element.errors.full_messages.join(' ')}"
      end
    end
  end
end
