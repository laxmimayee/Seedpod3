class MultipleChoiceQuestion < ActiveRecord::Base
  attr_accessor :answer_caught
  
  attr_accessor :attempted_students_count
  attr_accessor :correct_attempted_students_count
  attr_accessor :wrong_attempted_students_count
  attr_accessor :correct_attempted_students_and_answers
  attr_accessor :wrong_attempted_students_and_answers
  attr_accessor :option1_report
  attr_accessor :option1_class
  attr_accessor :option2_report
  attr_accessor :option2_class
  attr_accessor :option3_report
  attr_accessor :option3_class
  attr_accessor :option4_report
  attr_accessor :option4_class
end
