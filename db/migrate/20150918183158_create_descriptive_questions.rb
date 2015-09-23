class CreateDescriptiveQuestions < ActiveRecord::Migration
  def change
    create_table :descriptive_questions do |t|
      t.integer :test_id
      t.text :description
      t.text :answer

      t.timestamps null: false
    end
  end
end
