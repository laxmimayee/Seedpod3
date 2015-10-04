class StudentAnswer < ActiveRecord::Base
  belongs_to :multiple_choice_question, -> { where(:question_type =>  "multiple_choice")}, :foreign_key => :question_id
  belongs_to :descriptive_question, -> { where(:question_type =>  "descriptive")}, :foreign_key => :question_id

  attr_accessor :option1, :option_2, :option_3, :option_4, :description
end
