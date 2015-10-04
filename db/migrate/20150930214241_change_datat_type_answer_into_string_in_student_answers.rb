class ChangeDatatTypeAnswerIntoStringInStudentAnswers < ActiveRecord::Migration
  def change
  	change_column :student_answers, :answer, :string
  end
end
