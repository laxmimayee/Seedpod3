class AddQuestionTypeToDescriptiveQuestions < ActiveRecord::Migration
  def change
    add_column :descriptive_questions, :question_type, :string, default: 'descriptive'
  end
end
