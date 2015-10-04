class AddNoOfQuestionsAndNoOfCorrectAnswersToStudentTests < ActiveRecord::Migration
  def change
  	add_column :student_tests, :no_of_questions, :integer
  	add_column :student_tests, :no_of_correct_answers, :integer
  end
end
