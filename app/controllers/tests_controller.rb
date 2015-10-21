class TestsController < ApplicationController
  before_action :set_test, only: [:show, :edit, :update, :destroy]

  def index
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
    if params[:report].present?
      @test.report = "true"      
      @total_questions.each do |tq|
        if tq.question_type == "multiple_choice"
          @answer = []
          tq.attempted_students_count = StudentAnswer.where(question_id: tq.id, student_test_id: StudentTest.where(test_id: params[:id].to_i).select(:id)).count
          tq.correct_attempted_students_count = StudentAnswer.where(question_id: tq.id, result: true, student_test_id: StudentTest.where(test_id: params[:id].to_i).select(:id)).count
          tq.wrong_attempted_students_count = StudentAnswer.where(question_id: tq.id, result: false, student_test_id: StudentTest.where(test_id: params[:id].to_i).select(:id)).count
          
          correct_attempted_students = StudentTest.where(id: StudentAnswer.where(question_id: tq.id, result: true, student_test_id: StudentTest.where(test_id: params[:id].to_i).select(:id)).select(:student_test_id)).select(:user_id)
          correct_attempted_students_answers = StudentAnswer.where(question_id: tq.id, result: true, student_test_id: StudentTest.where(test_id: params[:id].to_i).select(:id)).select(:answer)
          tq.correct_attempted_students_and_answers = correct_attempted_students.each_with_index.map  do |student,index|
            correct_attempted_students_answers.each_with_index do |answer,index|
              @answer[index] = answer.answer
            end
            {user_id: student.user_id, answer: @answer[index]}
          end
          
          wrong_attempted_students = StudentTest.where(id: StudentAnswer.where(question_id: tq.id, result: false, student_test_id: StudentTest.where(test_id: params[:id].to_i).select(:id)).select(:student_test_id)).select(:user_id)
          wrong_attempted_students_answers = StudentAnswer.where(question_id: tq.id, result: false, student_test_id: StudentTest.where(test_id: params[:id].to_i).select(:id)).select(:answer)
          tq.wrong_attempted_students_and_answers = wrong_attempted_students.each_with_index.map  do |student,index|
            wrong_attempted_students_answers.each_with_index do |answer,index|
              @answer[index] = answer.answer
            end
            {user_id: student.user_id, answer: @answer[index]}
          end

          if tq.option_1 == tq.answer and tq.correct_attempted_students_count != 0
            tq.option1_report = "#{tq.correct_attempted_students_count} Choose - Correct!"
            tq.option1_class = "correct_option"
          else
            @option_1_wrong_count = 0
            tq.wrong_attempted_students_and_answers.each do |temp|
              if MultipleChoiceQuestion.where(id: tq.id, test_id: tq.test_id, option_1: temp[:answer]).present?
                @option_1_wrong_count = @option_1_wrong_count+1
              end
            end 
            if @option_1_wrong_count != 0
              tq.option1_report = "#{@option_1_wrong_count} Choose - Incorrect!"
              tq.option1_class = "incorrect_option"
            end
          end
          
          if tq.option_2 == tq.answer and tq.correct_attempted_students_count != 0
            tq.option2_report = "#{tq.correct_attempted_students_count} Choose - Correct!"
            tq.option2_class = "correct_option"
          else 
            @option_2_wrong_count = 0
            tq.wrong_attempted_students_and_answers.each do |temp|
              if MultipleChoiceQuestion.where(id: tq.id, test_id: tq.test_id, option_2: temp[:answer]).present?
                @option_2_wrong_count = @option_2_wrong_count+1
              end
            end 
            if @option_2_wrong_count != 0
              tq.option2_report = "#{@option_2_wrong_count} Choose - Incorrect!"
              tq.option2_class = "incorrect_option"
            end
          end
          
          if tq.option_3 == tq.answer and tq.correct_attempted_students_count != 0
            tq.option3_report = "#{tq.correct_attempted_students_count} Choose - Correct!"
            tq.option3_class = "correct_option"
          else 
            @option_3_wrong_count = 0
            tq.wrong_attempted_students_and_answers.each do |temp|
              if MultipleChoiceQuestion.where(id: tq.id, test_id: tq.test_id, option_3: temp[:answer]).present?
                @option_3_wrong_count = @option_3_wrong_count+1
              end
            end 
            if @option_3_wrong_count != 0
              tq.option3_report = "#{@option_3_wrong_count} Choose - Incorrect!"
              tq.option3_class = "incorrect_option"
            end
          end
          
          if tq.option_4 == tq.answer and tq.correct_attempted_students_count != 0
            tq.option4_report = "#{tq.correct_attempted_students_count} Choose - Correct!"
            tq.option4_class = "correct_option"
          else 
            @option_4_wrong_count = 0
            tq.wrong_attempted_students_and_answers.each do |temp|
              if MultipleChoiceQuestion.where(id: tq.id, test_id: tq.test_id, option_4: temp[:answer]).present?
                @option_4_wrong_count = @option_4_wrong_count+1
              end
            end 
            if @option_4_wrong_count != 0
              tq.option4_report = "#{@option_4_wrong_count} Choose - Incorrect!"
              tq.option4_class = "incorrect_option"
            end
          end
          
        end
        if tq.question_type == "descriptive"
          tq.attempted_students_count = StudentAnswer.where(question_id: tq.id, student_test_id: StudentTest.where(test_id: params[:id].to_i).select(:id)).count
          attempted_students =  StudentTest.where(id: StudentAnswer.where(question_id: tq.id, student_test_id: StudentTest.where(test_id: params[:id].to_i).select(:id)).select(:student_test_id)).select(:user_id)
          attempted_answers = StudentAnswer.where(question_id: tq.id, student_test_id: StudentTest.where(test_id: params[:id].to_i).select(:id)).select(:answer)          
          tq.attempted_students_and_answers = attempted_students.each_with_index.map  do |student,index|
            attempted_answers.each_with_index do |answer,index|
              @answer[index] = answer.answer
            end
            {user_id: student.user_id, answer: @answer[index]}
          end
        end

      end
    end
    
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

    if params[:student_test][:multiple_choice_questions_attributes].present?
      params[:student_test][:multiple_choice_questions_attributes].each do |each_question|
        @student_answer = StudentAnswer.new
        @student_answer.student_test_id = @student_test.id
        @student_answer.question_type = "multiple_choice"
        @student_answer.question_id = each_question[1][:id]
        @student_answer.answer = each_question[1][:answer_caught]
        @student_answer.result = get_result(@student_answer.question_type, @student_answer.question_id, @student_answer.answer)
        @student_answer.save
      end
    end
    if params[:student_test][:descriptive_questions_attributes].present?
      params[:student_test][:descriptive_questions_attributes].each do |each_question|
        @student_answer = StudentAnswer.new
        @student_answer.student_test_id = @student_test.id
        @student_answer.question_type = "descriptive"
        @student_answer.question_id = each_question[1][:id]
        @student_answer.answer = each_question[1][:answer_caught]
        @student_answer.result = get_result(@student_answer.question_type, @student_answer.question_id, @student_answer.answer)
        @student_answer.save
      end
    end
    @student_test.status = "completed"
    student_report(@student_test)

    redirect_to "/"
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
    elsif question_type == "descriptive"
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
