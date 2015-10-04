class CreateStudentAnswers < ActiveRecord::Migration
  def change
    create_table :student_answers do |t|
      t.integer :student_test_id
      t.string :question_type
      t.integer :question_id
      t.integer :answer

      t.timestamps null: false
    end
  end
end
