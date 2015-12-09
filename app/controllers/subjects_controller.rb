require 'google/api_client'

class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_teacher!, only:[:new,:create,:destroy,:edit,:update]


  # GET /subjects
  # GET /subjects.json
  def index
    @subjects = Subject.all
  end

  # GET /subjects/1
  # GET /subjects/1.json
  def show
  end

  # GET /subjects/new
  def new
    @subject = Subject.new
  end


  # GET /subjects/1/edit
  def edit
  end

  def init_client
    client = Google::APIClient.new
    client.authorization.access_token=current_user.token
    return client
  end

  # POST /subjects
  # POST /subjects.json
  def create
    parametros=subject_params
    client=init_client
    service = client.discovered_api('calendar', 'v3')

    calendar= {
      'summary'=> parametros[:name]+" 2016-"+parametros[:semester],
      'timeZone'=> "America/Mexico_City",
      'description'=> parametros[:body]
    }

    result = client.execute(
    :api_method => service.calendars.insert,
    :body => JSON.dump(calendar),
    :headers => {'Content-Type' => 'application/json'})

    parametros.store(:google_calendar_id,result.data.id)

    @subject=current_user.subjects.new(parametros)


    respond_to do |format|
      if @subject.save
        format.html { redirect_to @subject, notice: 'Subject was successfully created.' }
        format.json { render :show, status: :created, location: @subject }
      else
        format.html { render :new }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subjects/1
  # PATCH/PUT /subjects/1.json
  def update
    respond_to do |format|
      if @subject.update(subject_params)
        format.html { redirect_to @subject, notice: 'Subject was successfully updated.' }
        format.json { render :show, status: :ok, location: @subject }
      else
        format.html { render :edit }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subjects/1
  # DELETE /subjects/1.json
  def destroy
    @subject.destroy
    respond_to do |format|
      format.html { redirect_to subjects_url, notice: 'Subject was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subject
      @subject = Subject.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subject_params
      params.require(:subject).permit(:group_number,:semester,:name,:body)
    end
end
