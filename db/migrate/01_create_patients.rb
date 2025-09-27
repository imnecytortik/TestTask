class CreatePatients < ActiveRecord::Migration[7.0]
  def change
    create_table :patients do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :middle_name
      t.date :birthday, null: false
      t.string :gender, null: false
      t.integer :height
      t.decimal :weight, precision: 6, scale: 2

      t.timestamps
    end

    add_index :patients, [:first_name, :last_name, :middle_name, :birthday], unique: true, name: "index_patients_on_full_name_and_birthday"
  end
end
