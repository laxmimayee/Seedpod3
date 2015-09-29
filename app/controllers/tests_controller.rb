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
    redirect_to "/tests"
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
    redirect_to "/tests"
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

    if current_test_id != nil
      @test = Test.find(current_test_id)
      @multiple_choice_questions = MultipleChoiceQuestion.where(test_id: current_test_id)
      @descriptive_questions = DescriptiveQuestion.where(test_id: current_test_id)
      @total_questions = @multiple_choice_questions + @descriptive_questions
    else
      flash[:notice] = "Present No Exam Scheduled"
    end
  end

  private
  
  def set_test
    @test = Test.find(params[:id])
  end

  def test_params
    params.require(:test).permit(:test_name)
  end

end
