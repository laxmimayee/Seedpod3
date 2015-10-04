# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

=begin
def seed_teachers
  @user_teacher = User.find_by_role("teacher")
  unless @user_teacher.present?
    User.create(:name => "Teacher", :role => "teacher", :email => "example_teacher@gmail.com" , :password => "hellohello")
  end
end

seed_teachers

=end

 user = User.create(:name => "Teacher", :role => "teacher", :email => "teacher@example.com" , :password => "hellohello"
                  )  
user = User.create(:name => "Student", :role => "student", :email => "student@example.com" , :password => "hellohello"
                   )                    
  #user.skip_confirmation!
  #user.save
  
