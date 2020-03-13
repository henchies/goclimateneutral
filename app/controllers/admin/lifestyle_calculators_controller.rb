# frozen_string_literal: true

module Admin
  class LifestyleCalculatorsController < AdminController
    def index
      @calculators = calculators
    end

    def show
      @calculator = LifestyleCalculator.find(params[:id])
    end

    def new
      @calculator = LifestyleCalculator.find_or_initialize_by(
        countries: params[:countries].reject(&:blank?).map(&:downcase),
        version: nil
      )
    end

    def create
      @calculator = LifestyleCalculator.find_or_initialize_by(
        countries: params[:lifestyle_calculator][:countries].split(' '),
        version: nil
      )

      @calculator.attributes =
        params.require(:lifestyle_calculator).permit(
          :country, :housing_formula, :food_formula, :car_formula, :flights_formula, :consumption_formula, :public_formula
        ).merge(options_params)

      render(:new) && return unless @calculator.save

      redirect_to [:admin, @calculator]
    end

    private

    def options_params
      [:region, :home, :heating, :house_age, :green_electricity, :food, :car_type].map do |question|
        keys = params["#{question}_options_keys"]
        values = params["#{question}_options_values"]

        options = keys&.each_with_index&.map { |k, i| [k, values[i]] }&.to_h || {}
        options.reject! { |k, _| k.empty? }

        ["#{question}_options", (options unless options.empty?)]
      end.to_h
    end

    def calculators
      p = published_calculators.map do |calculator|
        [
          calculator.countries.map { |c| ISO3166::Country.new(c) },
          { published: calculator }
        ]
      end.to_h
      d = draft_calculators.map do |calculator|
        [
          calculator.countries.map { |c| ISO3166::Country.new(c) },
          { draft: calculator }
        ]
      end.to_h

      d.deep_merge(p)
    end

    # TODO: Move to model
    def published_calculators
      LifestyleCalculator.where(<<~SQL)
        (countries, version) IN (
          SELECT countries, MAX(version)
          FROM lifestyle_calculators
          GROUP BY countries
        )
      SQL
    end

    # TODO: Move to model
    def draft_calculators
      LifestyleCalculator.where(version: nil)
    end
  end
end
