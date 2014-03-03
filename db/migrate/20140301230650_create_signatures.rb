class CreateSignatures < ActiveRecord::Migration
  def change
    create_table :signatures do |t|
      t.string :email
      t.string :university

      t.timestamps
    end
  end
end
