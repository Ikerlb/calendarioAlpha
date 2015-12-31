class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    client=init_client
    service = client.discovered_api('calendar', 'v3')
    batch=Google::APIClient::BatchRequest.new
    current_user.subscriptions.each do |subscription|
      #print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      subject=subscription.subject
      batch.add(:api_method => service.events.list,:parameters => {'calendarId' => subject.google_calendar_id,'timeMin' => Chronic.parse('today'),'timeMax' => Chronic.parse('this sunday')})
    end
    result=client.execute(batch)
    @events=1
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new

  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create

  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update

  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy

  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:start_date, :end_date, :notification_time, :name)
    end
end
