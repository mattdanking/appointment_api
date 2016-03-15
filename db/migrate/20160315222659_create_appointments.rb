class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.string :start_time
      t.string :end_time
      t.string :first_name
      t.string :last_name
      t.string :comments

      t.timestamps null: false
    end
  end
end
