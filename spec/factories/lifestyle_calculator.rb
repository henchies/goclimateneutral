# frozen_string_literal: true

FactoryBot.define do
  factory :lifestyle_calculator do
    country { 'se' }
    region_options {
      {
        first: 1,
        second: 2
      }
    }
    home_options {
      {
        apartment: 5,
        house: 10
      }
    }
    heating_options {
      {
        district: 2,
        electricity: 1
      }
    }
    green_electricity_options {
      {
        yes: 1,
        no: 0
      }
    }
    food_options {
      {
        vegan: 1000,
        omnivore: 2000
      }
    }
    car_type_options {
      {
        petrol: 0.2,
        electricity: 0.001
      }
    }
    housing_formula { 'IF(green_electricity = 1, home * 0.5, home * 2)' }
    food_formula { 'food' }
    car_formula { 'car_type * car_distance' }
    flights_formula { 'flight_hours * 0.2' }
    other_formula { '1500' }
  end
end
