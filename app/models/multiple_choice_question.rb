class MultipleChoiceQuestion < ActiveRecord::Base
  attr_accessor :answer_caught
  
  attr_accessor :attempted_students_count
  attr_accessor :correct_attempted_students_count
  attr_accessor :wrong_attempted_students_count
  attr_accessor :correct_attempted_students
  attr_accessor :wrong_attempted_students
end
