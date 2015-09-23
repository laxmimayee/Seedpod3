class CreateMultipleChoiceQuestions < ActiveRecord::Migration
  def change
    create_table :multiple_choice_questions do |t|
      t.integer :test_id
      t.text :description
      t.string :option_1
      t.string :option_2
      t.string :option_3
      t.string :option_4
      t.string :answer

      t.timestamps null: false
    end
  end
end
