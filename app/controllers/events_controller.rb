class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
#  def index
#    client=init_client
#    service = client.discovered_api('calendar', 'v3')
#    batch=Google::APIClient::BatchRequest.new
#    current_user.subscriptions.each do |subscription|
#      subject=subscription.subject
#      batch.add(:api_method => service.events.list,:parameters => {'calendarId' => subject.google_calendar_id})
#    end
#    if subs.present?
#      result=client.execute(batch)
#      @events=result.data
#    end
#  end

  def index
    eventos=Array.new
    client=init_client
    service= client.discovered_api('calendar','v3')
    batch = Google::APIClient::BatchRequest.new
    current_user.subscriptions.each do |subscription|
      subject=subscription.subject
      batch.add(:api_method => service.events.list,:parameters => {'calendarId' => subject.google_calendar_id,'timeMin' => Time.now.to_datetime.rfc3339, 'timeMax' => Chronic.parse("next week").to_datetime.rfc3339}) do |result|
        if result.data.items.present?
           result.data.items.each do |evento|
            print evento.description
            eventos<<evento
           end
        end
      end
    end      
    client.execute(batch)
    @events=eventos
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @subjects=Subject.where(user_id: current_user.id)
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event=event_params
    print @event
    evento={'summary'=>@event[:name],
            'description'=>@event[:description],
            'location'=>@event[:location],
            'start' => { 'dateTime'=>@event[:start_date].to_datetime.rfc3339 },
            'end'=>{ 'dateTime'=>@event[:end_date].to_datetime.rfc3339 }
          }
    print evento
    client=init_client
    service = client.discovered_api('calendar', 'v3')
    result = client.execute!(
    :api_method => service.events.insert,
    :parameters => {:calendarId => Subject.find(@event[:subject_id]).google_calendar_id},
    :body_object => evento)
    redirect_to root_path
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
      fecha_inicio=params[:start_date]
      dia=fecha_inicio['fecha(3i)']
      mes=fecha_inicio['fecha(2i)']
      anio=fecha_inicio['fecha(1i)']
      hora=fecha_inicio['fecha(4i)']
      minuto=fecha_inicio['fecha(5i)']
      fecha=Time.new(anio.to_i,mes.to_i,dia.to_i,hora.to_i,minuto.to_i)
      fecha_fin=fecha+params[:duration].to_i.hours
      hash=params.permit(:name,:description,:duration,:location,:subject_id)
      hash.store(:start_date,fecha)
      hash.store(:end_date,fecha_fin)
      return hash
    end
end
