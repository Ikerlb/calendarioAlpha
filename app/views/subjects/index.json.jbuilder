json.array!(@subjects) do |subject|
  json.extract! subject, :id, :user_id, :group_number, :google_calendar_id, :name, :body
  json.url subject_url(subject, format: :json)
end
