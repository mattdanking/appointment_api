class Appointment < ActiveRecord::Base
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true 

  @new_appt = true
  @valid = false

  ## Checks if an appointment time is in the future ##
  def check_future
    current_start = DateTime.strptime(self.start_time,"%m/%d/%y %H:%M").to_time
    current_end = DateTime.strptime(self.end_time,"%m/%d/%y %H:%M").to_time

    p current_start
    p current_end

    if current_start > Time.now && current_end > Time.now
      @valid = true
    else
      @valid = false
    end
    @valid
    p @valid
  end

  ## Checks if an appointment time overlaps an existing appointment ##
  def check_overlap
    appointments = Appointment.all
    current_start = DateTime.strptime(self.start_time,"%m/%d/%y %H:%M").to_time
    current_end = DateTime.strptime(self.end_time,"%m/%d/%y %H:%M").to_time

    appointments.each do |appt|
      appt_start = DateTime.strptime(appt.start_time,"%m/%d/%y %H:%M").to_time
      appt_end = DateTime.strptime(appt.end_time,"%m/%d/%y %H:%M").to_time

      ## if the appointment being checked is a new appointment ##
      if @new_appt
        if current_start >= appt_start && current_start <= appt_end
          @valid = false
        elsif current_end >= appt_start && current_end <= appt_end
          @valid = false
        else
          @valid = true
        end

      ## if the appointment being checked is an old appointment being updated ##
      else
        if current_start > appt_start && current_start < appt_end
          @valid = false
        elsif current_end > appt_start && current_end < appt_end
          @valid = false
        else
          @valid = true
        end
      end

    end
    @valid
    p @valid
  end

  ## if the appointment is being updated, assigns new parameters before checking future and overlap ##
  def check_updated_params(params)
    p params
    self.assign_attributes(params)
    p self
    @new_appt = false

    if self.check_future && self.check_overlap
      @valid = true
    else
      @valid = false
    end
    @valid
    p @valid
  end

end