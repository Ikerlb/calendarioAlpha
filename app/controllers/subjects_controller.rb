require 'google/api_client'

class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_teacher!, only:[:new,:create,:update,:destroy,:edit, :created]

  # GET /subjects
  def index
    @subjects = Subject.all
  end

  def created
    @subjects = Subject.where(user_id: current_user.id)
    render "index"
  end

  # GET /subjects/1
  def show
  end

  # GET /subjects/new
  def new
    @subject = Subject.new
  end


  # GET /subjects/1/edit
  def edit
  end

  # POST /subjects
  def create
    parametros=subject_params
    client=init_client
    service = client.discovered_api('calendar', 'v3')

    calendar= {
      'summary'=> parametros[:name]+" 2016-1",
      'timeZone'=> "America/Mexico_City",
      'description'=> parametros[:body]
    }

    result = client.execute(
    :api_method => service.calendars.insert,
    :body => JSON.dump(calendar),
    :headers => {'Content-Type' => 'application/json'})

    parametros.store(:google_calendar_id,result.data.id)
    parametros.store(:semester,"2016-1")
    parametros.store(:user_id,current_user.id)
    @subject=Subject.new(parametros)

    respond_to do |format|
      if @subject.save
        format.html { redirect_to @subject, notice: 'Se ha creado la materia.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /subjects/1
  def update
    respond_to do |format|
      if @subject.update(subject_params)
        format.html { redirect_to @subject, notice: 'Se ha actualizado la materia.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /subjects/1
  # DELETE /subjects/1.json
  def destroy
    @subject.destroy
    respond_to do |format|
      client=init_client
      service = client.discovered_api('calendar', 'v3')
      client.execute(:api_method => service.calendars.delete,
                        :parameters => {'calendarId' => @subject.google_calendar_id})
      format.html { redirect_to subjects_url, notice: 'Se ha eliminado la materia.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subject
      @subject = Subject.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subject_params
      params.require(:subject).permit(:group_number,:name,:body)
    end
end 
