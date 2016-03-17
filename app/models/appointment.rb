class Appointment < ActiveRecord::Base
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true 

  def check_validity
    @appointments = Appointment.all
    current_start = DateTime.strptime(self.start_time,"%m/%d/%y %H:%M").to_time
    current_end = DateTime.strptime(self.end_time,"%m/%d/%y %H:%M").to_time
    valid = false

    if current_start > Time.now && current_end > Time.now
      valid = true
    else
      valid = false
    end

    @appointments.each do |appt|
      appt_start = DateTime.strptime(appt.start_time,"%m/%d/%y %H:%M").to_time
      appt_end = DateTime.strptime(appt.end_time,"%m/%d/%y %H:%M").to_time

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
