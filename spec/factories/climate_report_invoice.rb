# frozen_string_literal: true

FactoryBot.define do
  factory :climate_report_invoice do
    invoice_address { 'Testvägen 11' }
    amount { 100_00 }
    currency { 'sek' }
    co2e { 1818 }
    association :climate_report
  end
end
