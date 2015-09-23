class DescriptiveQuestionsController < ApplicationController
  before_action :set_descriptive_question, only: [:show, :edit, :update, :destroy]

  def new
    @descriptive_question = DescriptiveQuestion.new
    @@test_id = params["test_id"].to_i
  end

  def create
    params[:descriptive_question][:test_id] = @@test_id
    
    @descriptive_question = DescriptiveQuestion.create(descriptive_question_params)
    if @descriptive_question.errors.present?
      flash.now[:fail] = I18n.t :fail, :scope => [:descriptive_question, :create]
      render "new"
    else
      flash.now[:success] = I18n.t :success, :scope => [:descriptive_question, :create]
    redirect_to  "/tests/#{@@test_id}"
    end
  end

  def edit
    @@page = params[:page]
  end

  def update
    if @descriptive_question.update(descriptive_question_params)
      flash.now[:success] = I18n.t :success, :scope => [:descriptive_question, :update]
      if @@page != ""
        redirect_to "/tests/#{@descriptive_question.test_id}?page=#{@@page}"
      else
        redirect_to "/tests/#{@descriptive_question.test_id}"
      end
    else
      flash.now[:fail] = I18n.t :fail, :scope => [:descriptive_question, :update]
      render "edit"
    end
  end

  private
  
  def descriptive_question_params
    params.require(:descriptive_question).permit(:description, :answer)
  end

  def set_descriptive_question
    @descriptive_question = DescriptiveQuestion.find(params[:id])
  end
end
