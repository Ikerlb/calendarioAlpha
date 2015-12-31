class Subject < ActiveRecord::Base
  before_destroy { |subject| subject.subscriptions.destroy_all }
  belongs_to :user
  has_many :subscriptions
  has_many :users, through: :subscriptions
end
