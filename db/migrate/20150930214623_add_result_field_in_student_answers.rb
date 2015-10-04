class AddResultFieldInStudentAnswers < ActiveRecord::Migration
  def change
  	add_column :student_answers, :result, :boolean
  end
end
