module Api
  module V1
    class BmiProxyController < ApplicationController
      include HTTParty

      def create
        height = params.require(:height).to_f
        weight = params.require(:weight).to_f

        height_m = height / 100.0

        api_url = ENV.fetch("BMI_API_URL", "https://bmicalculatorapi.vercel.app/api/bmi")
        url = "#{api_url}/#{weight}/#{height_m.round(2)}"

        p url

        response = HTTParty.get(url)

        if response.success?
          render json: response.parsed_response
        else
          render json: { error: "BMI service error" }, status: :bad_gateway
        end
      end
    end
  end
end
