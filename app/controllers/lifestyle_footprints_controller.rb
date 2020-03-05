# frozen_string_literal: true

class LifestyleFootprintsController < ApplicationController
  def create
    calculator = LifestyleCalculator.find(params[:lifestyle_calculator_id])

    result = calculator.calculate(
      params.permit(:housing, :heating, :house_age, :food, :car_type, :car_distance, :flight_hours).to_h.symbolize_keys
    )
    total = result.values.sum

    render json: {
      housing: result[:housing].to_s,
      food: result[:food].to_s,
      car: result[:car].to_s,
      flights: result[:flights].to_s,
      other: result[:other].to_s,
      total: total.to_s,
      price: (total * 2 / 12).consumer_price(Currency::SEK).to_s
    }
  end
end
