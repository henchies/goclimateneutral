# frozen_string_literal: true

require 'csv'

class ImpactStatistics
  attr_reader :weeks

  def initialize
    @weeks = {}

    merge_field(:subscriber_payments_tonnes, subscribers_payments_tonnes)
    merge_field(:gift_cards_tonnes, gift_cards_tonnes)
    merge_field(:invoices_tonnes, invoices_tonnes)
    merge_field(:bought_projects_tonnes, bought_projects_tonnes)

    set_total_sold_tonnes
    add_missing_weeks
    set_zeros_for_missing_values
    sort_weeks
  end

  def to_csv
    CSV.generate do |csv|
      csv << [
        'Week of', 'Subscriber Payments (tonnes)', 'Gift Cards (tonnes)', 'Invoices (tonnes)', 'Total sold (tonnes)',
        'Bought Projects (tonnes)'
      ]

      weeks.each do |week_start, fields|
        csv << [
          week_start, fields[:subscriber_payments_tonnes].round(2), fields[:gift_cards_tonnes].round(2),
          fields[:invoices_tonnes].round(2), fields[:total_sold_tonnes].round(2),
          fields[:bought_projects_tonnes].round(2)
        ]
      end
    end
  end

  private

  def merge_field(field, tonnes_by_week)
    tonnes_by_week.each do |week_start, tonnes|
      @weeks[week_start] = {} unless @weeks[week_start].present?
      @weeks[week_start][field] = tonnes
    end
  end

  def subscribers_payments_tonnes
    payment_tonnes(StripeEvent.paid_charges.for_subscriptions)
  end

  def gift_cards_tonnes
    payment_tonnes(StripeEvent.paid_charges.for_gift_cards)
  end

  def invoices_tonnes
    sum_by_week(Invoice, :carbon_offset)
  end

  def bought_projects_tonnes
    sum_by_week(Project, :carbon_offset)
  end

  def set_total_sold_tonnes
    @weeks.each do |_, values|
      values[:total_sold_tonnes] =
        (values[:subscriber_payments_tonnes] || 0) +
        (values[:gift_cards_tonnes] || 0) +
        (values[:invoices_tonnes] || 0)
    end
  end

  def add_missing_weeks
    existing_weeks = @weeks.keys.map(&:to_date).sort
    existing_weeks.first.step(existing_weeks.last, 7) do |week_start|
      week_start_string = week_start.to_s
      @weeks[week_start_string] = {} if @weeks[week_start_string].nil?
    end
  end

  def set_zeros_for_missing_values
    @weeks.each do |_, fields|
      fields[:subscriber_payments_tonnes] = 0 if fields[:subscriber_payments_tonnes].nil?
      fields[:gift_cards_tonnes] = 0 if fields[:gift_cards_tonnes].nil?
      fields[:invoices_tonnes] = 0 if fields[:invoices_tonnes].nil?
      fields[:total_sold_tonnes] = 0 if fields[:total_sold_tonnes].nil?
      fields[:bought_projects_tonnes] = 0 if fields[:bought_projects_tonnes].nil?
    end
  end

  def sort_weeks
    @weeks = @weeks.sort.to_h
  end

  def payment_tonnes(stripe_events)
    payment_amounts_total(stripe_events)
      .transform_values { |sek_amount| sek_amount / 100 / LifestyleChoice::SEK_PER_TONNE }
  end

  def payment_amounts_total(stripe_events)
    payment_amounts_sek(stripe_events)
      .merge(payment_amounts_usd_in_sek(stripe_events)) { |_, v1, v2| v1 + v2 }
      .merge(payment_amounts_eur_in_sek(stripe_events)) { |_, v1, v2| v1 + v2 }
  end

  def payment_amounts_sek(stripe_events)
    sum_by_week(stripe_events.in_sek, :stripe_amount)
  end

  def payment_amounts_usd_in_sek(stripe_events)
    sum_by_week(stripe_events.in_usd, :stripe_amount)
      .transform_values { |usd_amount| usd_amount * LifestyleChoice::SEK_PER_USD }
  end

  def payment_amounts_eur_in_sek(stripe_events)
    sum_by_week(stripe_events.in_eur, :stripe_amount)
      .transform_values { |eur_amount| eur_amount * LifestyleChoice::SEK_PER_EUR }
  end

  def sum_by_week(relation, field)
    relation
      .group("date_trunc('week', created_at::date)")
      .sum(field)
      .transform_keys { |k| k.to_date.to_s }
  end
end