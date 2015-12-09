class AddSemesterToSubjects < ActiveRecord::Migration
  def change
    add_column :subjects, :semester, :string
  end
end
