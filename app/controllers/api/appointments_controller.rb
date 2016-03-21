class API::AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:update, :destroy]

  ## GET - list / filter appointments by start_time and end_time or first and last name ##
  def index
    start_time = params[:start_time]
    end_time = params[:end_time]
    first_name = params[:first_name]
    last_name = params[:last_name]

    if start_time && end_time
      @appointments = Appointment.where(start_time: start_time, end_time: end_time)
    elsif start_time
      @appointments = Appointment.where(start_time: start_time)
    elsif end_time
      @appointments = Appointment.where(end_time: end_time)
    elsif first_name & last_name
      @appointments = Appointment.where(first_name: first_name, last_name: last_name)
    elsif first_name
      @appointments = Appointment.where(first_name: first_name)
    else last_name
      @appointments = Appointment.where(last_name: last_name)
    end

    render json: @appointments, status: 200
  end

  ## POST - creates new appointment if in future and no overlap is True ##
  def create
    @appointment = Appointment.new(appointment_params)
    if @appointment.check_future && @appointment.check_overlap
      if @appointment.save
        render json: @appointment, status: 201
      else
        render json: @appointment.errors, status: 422
      end
    end
  end

  ## PATCH - find appt by id, updates new params before checking future and overlap ##
  def update
    if @appointment.check_updated_params(appointment_params)
      if @appointment.update(appointment_params)
        render json: @appointment, status: 200
      else
        render json: @appointment.errors, status: 422
      end
    else
      p "did not work"
    end
  end

  ## DELETE - find appt by id, and delete appt ##
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