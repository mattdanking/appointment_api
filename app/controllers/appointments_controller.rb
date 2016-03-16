class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:update, :destroy]

  def index
    @appointments = Appointment.all
    
    if start_time = params[:start_time]
      @appointments = Appointment.where(start_time: start_time)
    end

    if end_time = params[:end_time]
      @appointments = Appointment.where(end_time: end_time)
    end

    render json: @appointments, status: 200
  end

  def new
    @appointment = Appointment.new
  end

  def create
    @appointment = Appointment.new(appointment_params)

    if @appointment.save
      render json: @appointment, status: 201, location: @appointment
    else
      render json: @appointment.errors, status: 422
    end
  end

  def update
    if @appointment.update(appointment_params)
      render json: @appointment, status: :ok, location: @appointment
    else
      render json: @appointment.errors, status: 422
    end
  end

  def destroy
    @appointment.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def appointment_params
      params.require(:appointment).permit(:start_time, :end_time, :first_name, :last_name, :comments)
    end
end
