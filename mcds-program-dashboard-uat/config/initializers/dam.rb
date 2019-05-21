#auth = Struct.new(:name, :password)
obj = YAML.load_file(File.join(Rails.root, 'config', 'dam.yml'))[Rails.env].with_indifferent_access
obj[:uri_class] = obj[:uri_class].constantize

DAM_CONFIG = obj
