module Api
  module V1
    class BmiProxyController < ApplicationController
      include HTTParty

      before_action :set_patient

      # GET /api/v1/patients/:patient_id/bmi
      def show
        weight = @patient.weight.to_f
        height_m = (@patient.height.to_f / 100.0).round(2)

        api_url = ENV.fetch("BMI_API_URL", "https://bmicalculatorapi.vercel.app/api/bmi")
        url = "#{api_url}/#{weight}/#{height_m}"

        p url  # для отладки

        response = HTTParty.get(url)

        if response.success?
          render json: response.parsed_response
        else
          render json: { error: "BMI service error" }, status: :bad_gateway
        end
      end

      private

      def set_patient
        @patient = Patient.find(params[:patient_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Patient not found" }, status: :not_found
      end
    end
  end
end
