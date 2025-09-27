module Api
  module V1
    class PatientsController < ApplicationController
      before_action :set_patient, only: [:show, :update, :destroy]

      def index
        q = Patient.ransack(ransack_params)
        patients = q.result.distinct

        if params[:start_age].present? || params[:end_age].present?
          patients = patients.select do |p|
            age = p.age || -1
            ok1 = params[:start_age].present? ? age >= params[:start_age].to_i : true
            ok2 = params[:end_age].present? ? age <= params[:end_age].to_i : true
            ok1 && ok2
          end
        end

        limit = (params[:limit] || 20).to_i
        offset = (params[:offset] || 0).to_i

        render json: patients[offset, limit] || []
      end

      def show
        render json: @patient
      end

      def create
        @patient = Patient.new(patient_params)
        assign_doctors if params[:doctor_ids]

        if @patient.save
          render json: @patient, status: :created
        else
          render json: { errors: @patient.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        assign_doctors if params[:doctor_ids]
        if @patient.update(patient_params)
          render json: @patient
        else
          render json: { errors: @patient.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @patient.destroy
        head :no_content
      end

      private

      def set_patient
        @patient = Patient.find(params[:id])
      end

      def patient_params
        params.require(:patient).permit(:first_name, :last_name, :middle_name, :birthday, :gender, :height, :weight)
      end

      def ransack_params
        if params[:full_name].present?
          { m: "or", first_name_or_last_name_or_middle_name_cont: params[:full_name] }
        else
          {}.merge(params.slice(:gender))
        end
      end

      def assign_doctors
        doctor_ids = params[:doctor_ids]
        doctors = Doctor.where(id: doctor_ids)
        @patient.doctors = doctors
      end
    end
  end
end
