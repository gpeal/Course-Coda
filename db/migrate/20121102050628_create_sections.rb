class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.references :subject
      t.references :professor
      t.references :quarter
      t.references :year

      t.float :instruction
      t.string :instruction_breakdown
      t.integer :instruction_responses
      t.integer :instruction_enroll_count

      t.float :course
      t.string :course_breakdown
      t.integer :course_responses
      t.integer :course_enroll_count

      t.float :learned
      t.string :learned_breakdown
      t.integer :learned_responses
      t.integer :learned_enroll_count

      t.float :challenge
      t.string :challenge_breakdown
      t.integer :challenge_responses
      t.integer :challenge_enroll_count

      t.float :stimulation
      t.string :stimulation_breakdown
      t.integer :stimulation_responses
      t.integer :stimulation_enroll_count

      t.string :time_breakdown

      t.text :feedback

      t.string :school_breakdown
      t.string :class_breakdown
      t.string :reasons_breakdown
      t.string :interest_breakdown
      t.timestamps
    end

    create_table :subjects do |t|
      t.string :name
    end

    create_table :professor do |t|
      t.string :name
    end

    create_table :quarter do |t|
      t.string :name
    end

    create_table :year do |t|
      t.integer :year
    end
  end
end
