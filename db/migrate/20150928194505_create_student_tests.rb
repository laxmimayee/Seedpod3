class CreateStudentTests < ActiveRecord::Migration
  def change
    create_table :student_tests do |t|
      t.integer :user_id
      t.integer :test_id
      t.string :status

      t.timestamps null: false
    end
  end
end
