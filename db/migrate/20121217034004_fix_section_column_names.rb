class FixSectionColumnNames < ActiveRecord::Migration
  def change
    rename_column :sections, :challenge, :challenged
    rename_column :sections, :challenge_breakdown, :challenged_breakdown
    rename_column :sections, :challenge_responses, :challenged_responses
    rename_column :sections, :challenge_enroll_count, :challenged_enroll_count

    rename_column :sections, :stimulation, :stimulated
    rename_column :sections, :stimulation_breakdown, :stimulated_breakdown
    rename_column :sections, :stimulation_responses, :stimulated_responses
    rename_column :sections, :stimulation_enroll_count, :stimulated_enroll_count
  end
end
