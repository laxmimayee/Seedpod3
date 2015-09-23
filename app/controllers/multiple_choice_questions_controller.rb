class MultipleChoiceQuestionsController < ApplicationController
  before_action :set_multiple_choice_question, only: [:show, :edit, :update, :destroy]

  def new
    @multiple_choice_question = MultipleChoiceQuestion.new
    @@test_id = params["test_id"].to_i
  end

  def create
    params[:multiple_choice_question][:test_id] = @@test_id
    
    @multiple_choice_question = MultipleChoiceQuestion.create(multiple_choice_question_params)
    if @multiple_choice_question.errors.present?
      flash.now[:fail] = I18n.t :fail, :scope => [:multiple_choice_question, :create]
      render "new"
    else
      flash.now[:success] = I18n.t :success, :scope => [:multiple_choice_question, :create]
    redirect_to  "/tests/#{@@test_id}"
    end
  end

  def edit    
    @@page = params[:page]
  end

  def update
    if @multiple_choice_question.update(multiple_choice_question_params)
      flash.now[:success] = I18n.t :success, :scope => [:multiple_choice_question, :update]
      if @@page != ""
        redirect_to "/tests/#{@multiple_choice_question.test_id}?page=#{@@page}" 
      else
        redirect_to "/tests/#{@multiple_choice_question.test_id}"    
      end
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:multiple_choice_question, :update]
      render "edit"
    end
  end

  private
  
  def multiple_choice_question_params
    params.require(:multiple_choice_question).permit(:test_id, :description, :option_1, :option_2, :option_3, :option_4, :answer)
  end

  def set_multiple_choice_question
    @multiple_choice_question = MultipleChoiceQuestion.find(params[:id])
  end
end
