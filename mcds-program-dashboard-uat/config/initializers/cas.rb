# This is temporary until McDonald's changes the url they are sending the SAML token to.
CAS_CONFIG = YAML.load_file(
  File.join(Rails.root, 'config', 'cas.yml')
)[Rails.env].with_indifferent_access
