class Patient < ApplicationRecord
  has_and_belongs_to_many :doctors, join_table: "doctors_patients"
  has_many :bmr_results, dependent: :destroy

  validates :first_name, :last_name, :birthday, presence: true
  validates :gender, inclusion: { in: %w[male female other], message: "%{value} is not a valid gender" }

  validates :first_name, uniqueness: { scope: [:last_name, :middle_name, :birthday], message: "same person already exists" }

  def age
    return unless birthday
    now = Date.current
    now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
  end

  # ✅ Разрешаем поиск по этим полям через Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[id first_name last_name middle_name birthday gender height weight created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[doctors bmr_results]
  end
end
