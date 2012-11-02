class Section < ActiveRecord::Base
  attr_accessible :instruction, :instruction_breakdown,  :instruction_responses, :instruction_enroll_count
  attr_accessible :course, :course_breakdown, :course_responses, :course_enroll_count
  attr_accessible :learned, :learned_breakdown, :learned_responses, :learned_enroll_count
  attr_accessible :challenge, :challenge_breakdown, :challenge_responses, :challenge_enroll_count
  attr_accessible :stimulation, :stimulation_breakdown, :stimulation_responses, :stimulation_enroll_count
  attr_accessible :time_breakdown, :feedback, :school_breakdown, :class_breakdown, :reasons_breakdown, :interest_breakdown
end
