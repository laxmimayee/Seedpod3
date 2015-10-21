class DescriptiveQuestion < ActiveRecord::Base  
  attr_accessor :answer_caught

  attr_accessor :attempted_students_count
  attr_accessor :attempted_students_and_answers
end
