class Capture < ActiveRecord::Base
  belongs_to :user

  serialize  :data, JSON

  def self.generate(opts = {})
    self.create(parse_generate_params(opts)) if Killswitch.capture_behavior_enabled?
  end

  def self.parse_generate_params(opts = {})
    opts = opts.with_indifferent_access

    opts[:data] ||= {}
    data_subhash = opts.slice!(*self.columns.map(&:name))
    opts[:data].merge!(data_subhash)
    opts
  end

end
