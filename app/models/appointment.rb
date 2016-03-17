class Appointment < ActiveRecord::Base
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true 

  def check_validity
    @appointments = Appointment.all
    current_start = self.start_time
    current_end = self.end_time
    valid = false

    if current_start > Time.now && current_end > Time.now
      valid = true
    else
      valid = false
    end

    @appointments.each do |appt|
      if current_start >= appt.start_time && current_start <= appt.end_time
        valid = false
      elsif current_end >= appt.start_time && current_end <= appt.end_time
        valid = false
      else
        valid = true
      end
    end
    valid
  end
end
