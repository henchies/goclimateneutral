# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LifestyleCalculator do
  describe '#calculate' do
    let(:answers) do
      {
        region: 'first',
        home: 'apartment',
        heating: 'district',
        house_age: 'pre1920',
        green_electricity: 'yes',
        food: 'omnivore',
        car_type: 'electricity',
        car_distance: 1000,
        flight_hours: 2
      }
    end

    [:housing, :food, :car, :flights, :other].each do |category|
      describe "#{category} calculation" do
        let(:subtotal_formula) { "#{category}_formula".to_sym }

        it 'resolves formulas' do
          calculator = build(:lifestyle_calculator, subtotal_formula => '1 + 1')

          result = calculator.calculate(answers)

          expect(result[category]).to eq(GreenhouseGases.new(2))
        end

        it 'makes car_distance available' do
          calculator = build(:lifestyle_calculator, subtotal_formula => 'car_distance')

          result = calculator.calculate(answers)

          expect(result[category]).to eq(GreenhouseGases.new(1000))
        end

        it 'makes flight_hours available' do
          calculator = build(:lifestyle_calculator, subtotal_formula => 'flight_hours')

          result = calculator.calculate(answers)

          expect(result[category]).to eq(GreenhouseGases.new(2))
        end

        it 'makes region answer value available' do
          calculator = build(
            :lifestyle_calculator,
            :region_options => { first: 10 },
            subtotal_formula => 'region'
          )

          result = calculator.calculate(answers)

          expect(result[category]).to eq(GreenhouseGases.new(10))
        end

        it 'makes home answer value available' do
          calculator = build(
            :lifestyle_calculator,
            :home_options => { apartment: 10 },
            subtotal_formula => 'home'
          )

          result = calculator.calculate(answers)

          expect(result[category]).to eq(GreenhouseGases.new(10))
        end

        it 'makes heating answer value available' do
          calculator = build(
            :lifestyle_calculator,
            :heating_options => { district: 5 },
            subtotal_formula => 'heating'
          )

          result = calculator.calculate(answers)

          expect(result[category]).to eq(GreenhouseGases.new(5))
        end

        it 'makes house_age answer value available' do
          calculator = build(
            :lifestyle_calculator,
            :house_age_options => { pre1920: 5 },
            subtotal_formula => 'house_age'
          )

          result = calculator.calculate(answers)

          expect(result[category]).to eq(GreenhouseGases.new(5))
        end

        it 'makes green_electricity answer value available' do
          calculator = build(
            :lifestyle_calculator,
            :green_electricity_options => { yes: 5 },
            subtotal_formula => 'green_electricity'
          )

          result = calculator.calculate(answers)

          expect(result[category]).to eq(GreenhouseGases.new(5))
        end

        it 'makes food answer value available' do
          calculator = build(
            :lifestyle_calculator,
            :food_options => { omnivore: 5 },
            subtotal_formula => 'food'
          )

          result = calculator.calculate(answers)

          expect(result[category]).to eq(GreenhouseGases.new(5))
        end

        it 'makes car_type answer value available' do
          calculator = build(
            :lifestyle_calculator,
            :car_type_options => { electricity: 5 },
            subtotal_formula => 'car_type'
          )

          result = calculator.calculate(answers)

          expect(result[category]).to eq(GreenhouseGases.new(5))
        end

        context 'when omitting all options and formulas' do
          it 'sets results to 0' do
            calculator = described_class.new

            result = calculator.calculate(answers)

            expect(result[category]).to eq(GreenhouseGases.new(0))
          end
        end
      end
    end
  end
end
