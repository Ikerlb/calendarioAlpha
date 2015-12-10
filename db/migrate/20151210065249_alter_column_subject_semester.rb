class AlterColumnSubjectSemester < ActiveRecord::Migration
  def change
  	change_column :subjects, :semester, :string
  end
end
