module Api
  module V1
    class DoctorsController < ApplicationController
      before_action :set_doctor, only: [:show, :update, :destroy]

      def index
        limit = (params[:limit] || 20).to_i
        offset = (params[:offset] || 0).to_i
        doctors = Doctor.all
        render json: doctors[offset, limit] || []
      end

      def show
        render json: @doctor
      end

      def create
        @doctor = Doctor.new(doctor_params)
        if @doctor.save
          render json: @doctor, status: :created
        else
          render json: { errors: @doctor.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @doctor.update(doctor_params)
          render json: @doctor
        else
          render json: { errors: @doctor.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @doctor.destroy
        head :no_content
      end

      private

      def set_doctor
        @doctor = Doctor.find(params[:id])
      end

      def doctor_params
        params.require(:doctor).permit(:first_name, :last_name, :middle_name)
      end
    end
  end
end
