module TestsHelper
	def get_student_answer(question_id,test_id,question_type)
		student_test_id = StudentTest.where(user_id: current_user.id, test_id: test_id).first.id
		student_answer = StudentAnswer.where(student_test_id: student_test_id, question_type: question_type, question_id: question_id).first.answer
	end	

	def get_student_result(question_id,test_id,question_type)
		student_test_id = StudentTest.where(user_id: current_user.id, test_id: test_id).first.id
		student_answer = StudentAnswer.where(student_test_id: student_test_id, question_type: question_type, question_id: question_id).first.result
	end	

	def get_student_test_result(test_id)
		no_of_correct_answers = StudentTest.where(test_id: test_id, user_id: current_user.id).first.no_of_correct_answers
	end
end
