class CreateLifestyleCalculators < ActiveRecord::Migration[6.0]
  def change
    create_table :lifestyle_calculators do |t|
      t.timestamps
      t.text :country
      t.integer :version
      t.jsonb :region_options
      t.jsonb :home_options
      t.jsonb :heating_options
      t.jsonb :house_age_options
      t.jsonb :green_electricity_options
      t.jsonb :food_options
      t.jsonb :car_type_options
      t.jsonb :values
      t.text :housing_formula
      t.text :food_formula
      t.text :car_formula
      t.text :flights_formula
      t.text :other_formula
    end
  end
end
