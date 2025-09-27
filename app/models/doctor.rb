class Doctor < ApplicationRecord
  has_and_belongs_to_many :patients, join_table: "doctors_patients"
  validates :first_name, :last_name, presence: true
end
