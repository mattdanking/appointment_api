class Appointment < ActiveRecord::Base
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true 

  def check_validity
    @appointments = Appointment.all
    current_start = self.start_time.to_datetime
    current_end = self.end_time.to_datetime
    valid = false

    if current_start > Time.now && current_end > Time.now
      valid = true
    else
      valid = false
    end

    @appointments.each do |appt|
      appt_start = appt.start_time.to_datetime
      appt_end = appt.end_time.to_datetime

      if current_start >= appt_start && current_start <= appt_end
        valid = false
      elsif current_end >= appt_start && current_end <= appt_end
        valid = false
      else
        valid = true
      end
    end
    valid
  end
end
