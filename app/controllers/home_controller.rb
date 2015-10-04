class HomeController < ApplicationController
  skip_authorization_check

  def index
    if current_user.present?
      if current_user.teacher?
        @tests = Test.where.not(status: "completed").order("created_at ASC")
        @completed_tests = Test.where(status: "completed").order("created_at ASC")
        # @completed_tests = Test.where(status: "completed").order("created_at ASC")
        render "teacher_index"
      elsif current_user.student?
        @current_test_id = Test.find_by_status("activated")
        if Test.find_by_status("activated") and !StudentTest.where(status: "completed", user_id: current_user.id, test_id: @current_test_id).present?
          @current_test = Test.find(@current_test_id)
        else
          @current_test_id = nil
        end
        @student_completed_tests = StudentTest.where(status: "completed", user_id: current_user.id).order("created_at ASC")
      end    
    end
    
  end

end
