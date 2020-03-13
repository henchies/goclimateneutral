# frozen_string_literal: true

FactoryBot.define do
  factory :lifestyle_calculator do
    countries { ['se'] }
    region_options do
      {
        first: '1',
        second: '2'
      }
    end
    home_options do
      {
        apartment: '5',
        house: '10'
      }
    end
    heating_options do
      {
        district: '2',
        electricity: '1'
      }
    end
    green_electricity_options do
      {
        yes: '0',
        no: '0'
      }
    end
    food_options do
      {
        vegan: '1000',
        omnivore: '2000'
      }
    end
    car_type_options do
      {
        petrol: '0.2',
        electricity: '0.001'
      }
    end
    housing_formula { 'IF(green_electricity_answer = "yes", home * 0.5, home * 2)' }
    food_formula { 'food' }
    car_formula { 'car_type * car_distance' }
    flights_formula { 'flight_hours * 0.2' }
    consumption_formula { '1500' }
    public_formula { '2000' }
  end
end
