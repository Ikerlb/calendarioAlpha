class RenameHasSubjectsToSubscriptions < ActiveRecord::Migration
  def change
  	rename_table :has_subjects, :subscriptions
  end
end
