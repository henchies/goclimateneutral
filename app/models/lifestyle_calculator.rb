# frozen_string_literal: true

class LifestyleCalculator < ApplicationRecord
  CATEGORIES = [:housing, :food, :car, :flights, :consumption, :public].freeze
  OPTION_QUESTIONS = [:region, :home, :heating, :house_age, :green_electricity, :food, :car_type].freeze
  INTEGER_QUESTIONS = [:car_distance, :flight_hours].freeze

  validates_presence_of :housing_formula, :food_formula, :car_formula, :flights_formula, :consumption_formula, :public_formula
  validate :countries_exist, :options_have_formulas, :formulas_are_well_formed

  def calculate(answers)
    calculator = Dentaku::Calculator.new
    calculator.store(values_from_answers(answers))
    results = calculator.solve!(formulas_from_answers(answers))

    extract_categories_from_results(results)
  end

  private

  def values_from_answers(answers)
    integer_question_values = answers.slice(*INTEGER_QUESTIONS)
    answer_values = answers.slice(*OPTION_QUESTIONS).transform_keys { |k| "#{k}_answer" }

    [integer_question_values, answer_values].reduce(&:merge)
  end

  def formulas_from_answers(answers)
    option_formulas = translate_option_answers(answers.slice(*OPTION_QUESTIONS))
    category_formulas = CATEGORIES.map { |c| ["#{c}_result".to_sym, send("#{c}_formula")] }.to_h

    [option_formulas, category_formulas].reduce(&:merge)
  end

  def translate_option_answers(answers)
    answers.map do |question, answer|
      options = send("#{question}_options")
      value = options[answer] if options&.any?
      [question, value]
    end.to_h
  end

  def extract_categories_from_results(results)
    CATEGORIES.map do |category|
      [
        category,
        GreenhouseGases.new(results["#{category}_result".to_sym]&.ceil || 0)
      ]
    end.to_h
  end

  def countries_exist
    return if countries.nil?

    errors.add(:countries, 'must be either nil or not empty') if countries.empty?

    countries.each do |country|
      ISO3166::Country.new(country).present? ||
        errors.add(:countries, "countains invalid country '#{country}'")
    end
  end

  def options_have_formulas
    [
      :region_options, :home_options, :heating_options, :house_age_options, :green_electricity_options, :food_options,
      :car_type_options
    ].each do |options_field|
      options = send(options_field)

      next if options.nil?

      errors.add(options_field, 'must be either nil or not empty') if options.empty?

      options.each do |key, formula|
        key.match?(/\A[a-z_]+\z/) ||
          errors.add(options_field, "contains option with invalid key '#{key}'")

        validation_calculator.ast(formula)
      rescue Dentaku::ParseError => e
        errors.add(options_field, "contains invalid formula for '#{key}': #{e.message}")
      end
    end
  end

  def formulas_are_well_formed
    [
      :housing_formula, :food_formula, :car_formula, :flights_formula, :consumption_formula, :public_formula
    ].each do |formula_field|
      formula = send(formula_field)
      validation_calculator.ast(formula)
    rescue Dentaku::ParseError => e
      errors.add(formula_field, "is not a valid formula: #{e.message}")
    end
  end

  def validation_calculator
    @validation_calculator ||= Dentaku::Calculator.new
  end
end
