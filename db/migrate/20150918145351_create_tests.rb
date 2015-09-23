class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.string :test_name

      t.timestamps null: false
    end
  end
end
