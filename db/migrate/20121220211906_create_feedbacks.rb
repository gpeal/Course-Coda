class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.text :feedback
      t.integer :section_id
      t.boolean :sentiment

      t.timestamps
    end
  end
end
