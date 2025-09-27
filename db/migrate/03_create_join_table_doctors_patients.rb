class CreateJoinTableDoctorsPatients < ActiveRecord::Migration[7.0]
  def change
    create_table :doctors_patients, id: false do |t|
      t.bigint :doctor_id, null: false
      t.bigint :patient_id, null: false
    end

    add_index :doctors_patients, [:doctor_id, :patient_id], unique: true
    add_foreign_key :doctors_patients, :doctors
    add_foreign_key :doctors_patients, :patients
  end
end
