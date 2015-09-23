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
    @multiple_choice_questions = MultipleChoiceQuestion.where(test_id: params[:id].to_i).order("created_at ASC").paginate(page: params[:page], per_page:1)
  end

  def activate_test
    if !Test.find_by_status("activated")
      flash[:notice] = "Test Activated"
      p "do activatie"
    else
      p "activation not possible"
      flash[:notice] = "Please Deactvate Activated Test"
    end
    redirect_to "/tests"
  end

  def deactivate_test
    if Test.find_by_status("activated") && Test.find(params[:test_id]).status == "activated"
      flash[:notice] = "Test Deactivated"
    else
      flash[:notice] = "no Test in active"
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

  private
  
  def set_test
    @test = Test.find(params[:id])
  end

  def test_params
    params.require(:test).permit(:test_name)
  end

end
