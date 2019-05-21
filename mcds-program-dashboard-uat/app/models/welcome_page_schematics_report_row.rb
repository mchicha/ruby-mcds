class WelcomePageSchematicsReportRow
  attr_accessor :parent, :children

  def initialize(opts = {})
    @parent = opts[:parent]
    @children = opts[:children] || []
  end

  def sort_children
    @children.sort_by! do |child|
      child.test? ? 10 : 1
    end
  end
end
