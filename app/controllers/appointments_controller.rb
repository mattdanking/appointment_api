class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:update, :destroy]

  def index
    start_time = params[:start_time]
    end_time = params[:end_time]

    if start_time && end_time 
      @appointments = Appointment.where(start_time: start_time, end_time: end_time)
    elsif start_time
      @appointments = Appointment.where(start_time: start_time)
    elsif end_time
      @appointments = Appointment.where(end_time: end_time)
    else
      @appointments = Appointment.all
    end

    render json: @appointments, status: 200
  end

  def create
    @appointment = Appointment.new(appointment_params)

    if @appointment.check_validity.save
      render json: @appointment, status: 201, location: @appointment
    else
      render json: @appointment.errors, status: 422
    end
  end

  def update
    if @appointment.check_validity.update(appointment_params)
      render json: @appointment, status: 200, location: @appointment
    else
      render json: @appointment.errors, status: 422
    end
  end

  def destroy
    @appointment.destroy
    head 204
  end

  private
    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    def appointment_params
      params.require(:appointment).permit(:start_time, :end_time, :first_name, :last_name, :comments)
    end
end
