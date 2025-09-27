module Api
  module V1
    class BmrsController < ApplicationController
      before_action :set_patient

      def create
        formula = params.require(:formula)
        calculator = BmrCalculator.new(@patient)
        value = calculator.calculate(formula)
        bmr = @patient.bmr_results.create!(formula: formula, value: value,
                                           metadata: { weight: @patient.weight, height: @patient.height })
        render json: { id: bmr.id, value: bmr.value, formula: bmr.formula,
                       created_at: bmr.created_at }
      rescue ArgumentError => e
        render json: { error: e.message }, status: :bad_request
      end

      def index
        limit = (params[:limit] || 20).to_i
        offset = (params[:offset] || 0).to_i
        results =
          @patient.bmr_results.order(created_at: :desc).offset(offset).limit(limit)
        render json: results
      end

      private

      def set_patient
        @patient = Patient.find(params[:patient_id])
      end
    end
  end
end
