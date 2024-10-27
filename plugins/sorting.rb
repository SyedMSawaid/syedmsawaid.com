# plugins/project_sorting.rb
module Sorting
  def sorted_by_launch_date
    sort_by { |project| project.data.launched }.reverse
  end
end

Array.include Sorting
