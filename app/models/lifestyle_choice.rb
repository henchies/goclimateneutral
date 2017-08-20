class LifestyleChoice < ApplicationRecord
  has_and_belongs_to_many :users

  SEK_PER_TONNE = 40
  BUFFER_SIZE = 2
  SEK_PER_DOLLAR = 8.5

  def self.get_lifestyle_choice_price choices

    if choices == []
      return "x"
    end

    tonne_co2 = get_lifestyle_choice_tonnes choices

    if I18n.locale == :en
      price = tonne_co2 * SEK_PER_TONNE / SEK_PER_DOLLAR / 12
      rounded_price_with_buffer = (price * BUFFER_SIZE).round(1)
    else
      price = tonne_co2 * SEK_PER_TONNE / 12
      rounded_price_with_buffer = (price * BUFFER_SIZE / 5).ceil * 5
    end

    rounded_price_with_buffer
  end 

  def self.get_lifestyle_choice_tonnes choices
    tonne_co2 = 0
    choices.each do |choice|
      lifestyle_choice = LifestyleChoice.find choice
      tonne_co2 = tonne_co2 + lifestyle_choice.co2
    end
    tonne_co2
  end

  def self.get_lifestyle_choice_co2
    lifestyle_choice_co2 = []
    LifestyleChoice.all.each do |choice|
      lifestyle_choice_co2[choice.id] = choice.co2
    end
    lifestyle_choice_co2
  end
end