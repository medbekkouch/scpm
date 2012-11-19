class Spider < ActiveRecord::Base
  belongs_to    :milestone_name,  :foreign_key=>"milestone_id"
  belongs_to    :project
  has_many      :spider_values
  has_many      :spider_consolidations
  has_many      :lifecycle_questions, :through=>:spider_values
end
