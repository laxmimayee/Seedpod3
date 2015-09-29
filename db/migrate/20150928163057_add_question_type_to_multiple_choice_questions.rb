class AddQuestionTypeToMultipleChoiceQuestions < ActiveRecord::Migration
  def change
    add_column :multiple_choice_questions, :question_type, :string, default: 'multiple_choice'
  end
end
