namespace :svg do

  desc "Load svg files"
  task import: :environment do
    zone_folders = Dir.glob(File.join(Rails.root,"public", "canvas", "*/"))

    zone_folders.each do |zone_folder|
      zone_name = File.basename(zone_folder)

      document_folders  = Dir.glob(File.join(Rails.root,"public", "canvas", zone_name, "*/"))

      document_folders.each do |df|
        document_filename = df.split('/').last
        document_file     = Dir.glob(File.join(df, "*.svg")).reject{|path| path.scan(/\/background.svg/).any?}.last
        layout_folders    = Dir.glob(File.join(df, "*/"))
        main_document = Svg::MainDocument.new(document_file, document_filename, layout_folders, zone_name)
        main_document.find_or_create

        layout_folders.each do |lf|
          layout_files    = Dir.glob(File.join(lf, "*.svg"))
          layout_filename = lf.split('/').last.scan(/\d{1,2}.\d{1,2}/).first

          layout_files.each do |file|
            layout_document = Svg::SubDocument.new(file, layout_filename)
            layout_document.find_or_create
          end

        end
      end
    end

    Document.where.not(zone_id: nil).each do |document|
      document.update_attribute(:print_scale, 3000 / document.width)
    end

  end
end
