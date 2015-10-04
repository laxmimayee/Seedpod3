class TestsController < ApplicationController
  before_action :set_test, only: [:show, :edit, :update, :destroy]

  def index
    @tests = Test.where.not(status: "completed").order("created_at ASC")
  end

  def new
    @test = Test.new
  end

  def create
    @test = Test.create(test_params)
    if @test.errors.present?
      flash.now[:fail] = I18n.t :fail, :scope => [:test, :create]
      render "new"
    else
      flash.now[:success] = I18n.t :success, :scope => [:test, :create]
      @test.status = "deactivated"
      @test.save
      redirect_to @test
    end
  end

  def show
    @multiple_choice_questions = MultipleChoiceQuestion.where(test_id: params[:id].to_i)
    @descriptive_questions = DescriptiveQuestion.where(test_id: params[:id].to_i)

    @total_questions = @multiple_choice_questions + @descriptive_questions

    @total_questions.sort_by! {|u| u.created_at}

    @total_questions = @total_questions.paginate(page: params[:page], per_page:1)
  end

  def activate_test
    if Test.find_by_status("activated")
      flash[:notice] = "Please Deactvate Activated Test"
    else
      @test = Test.find(params[:test_id])
      @test.status = "activated"
      @test.save
      flash[:notice] = "Test Activated"      
    end
    redirect_to "/"
  end

  def deactivate_test
    if Test.find_by_status("activated") && Test.find(params[:test_id]).status == "activated"
      @test = Test.find(params[:test_id])
      @test.status = "deactivated"
      @test.save
      flash[:notice] = "Test Deactivated"
    elsif Test.find_by_status("activated") && Test.find(params[:test_id]).status != "activated"
      flash[:notice] = "This Test is Not Active"
    else
      flash[:notice] = "No Test Is Active"
    end
    redirect_to "/"
  end

  def complete_test
    @test = Test.find(params[:test_id])
    @test.status = "completed"
    @test.save
    flash[:notice] = "Test Moved To Ccompleted"
    
    redirect_to "/tests"
  end

  def completed_tests
    @tests = Test.where(status: "completed").order("created_at ASC")
  end

  def current_exam
    current_test_id = Test.find_by_status("activated")? Test.find_by_status("activated").id : nil
    
    if current_test_id != nil and !StudentTest.where(user_id: current_user.id, test_id: current_test_id).present? 
      @test = Test.find(current_test_id)
     
      @student_test = StudentTest.new
      @student_test.multiple_choice_questions = MultipleChoiceQuestion.where(test_id: current_test_id)
      @student_test.descriptive_questions = DescriptiveQuestion.where(test_id: current_test_id)
      @student_test.test_id = @test.id
    else
      flash[:notice] = "Present No Exam Scheduled"
    end
  end

  def submit_exam
    @student_test = StudentTest.create(student_test_params)
    
    params[:student_test][:multiple_choice_questions_attributes].each do |each_question|
      @student_answer = StudentAnswer.new
      @student_answer.student_test_id = @student_test.id
      @student_answer.question_type = "multiple_choice"
      @student_answer.question_id = each_question[1][:id]
      @student_answer.answer = each_question[1][:answer_caught]
      @student_answer.result = get_result(@student_answer.question_type, @student_answer.question_id, @student_answer.answer)
      @student_answer.save
    end

    params[:student_test][:descriptive_questions_attributes].each do |each_question|
      @student_answer = StudentAnswer.new
      @student_answer.student_test_id = @student_test.id
      @student_answer.question_type = "desriptive"
      @student_answer.question_id = each_question[1][:id]
      @student_answer.answer = each_question[1][:answer_caught]
      @student_answer.result = get_result(@student_answer.question_type, @student_answer.question_id, @student_answer.answer)
      @student_answer.save
    end  
    
    @student_test.status = "completed"
    student_report(@student_test)

    redirect_to "/tests/current_exam"
  end

  private
  
  def set_test
    @test = Test.find(params[:id])
  end

  def test_params
    params.require(:test).permit(:test_name)
  end

  def student_test_params
    params.require(:student_test).permit(:test_id, :user_id)
  end

  def get_result(question_type,question_id,answer)
    if question_type == "multiple_choice"
      if MultipleChoiceQuestion.find(question_id).answer == answer
        true
      else
        false
      end
    elsif question_type == "desriptive"
      if DescriptiveQuestion.find(question_id).answer == answer
        true
      else
        false
      end
    end
  end

  def student_report(student_test)
    student_test.no_of_questions = StudentAnswer.where(student_test_id: student_test.id).count
    student_test.no_of_correct_answers = StudentAnswer.where(result: "t",student_test_id: student_test.id).count
    
    student_test.save
  end

end
