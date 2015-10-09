class Test < ActiveRecord::Base
  has_many :student_tests
  validates :test_name, :uniqueness => {:case_sensitive => false}
  attr_accessor :is_it_report
end
