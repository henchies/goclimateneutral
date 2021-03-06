# frozen_string_literal: true

class StripePayout < ApplicationRecord
  def self.update_payouts
    list = Stripe::Payout.list(limit: 100)
    last_id = ''

    until list['data'].empty?

      list['data'].each do |p|
        if StripePayout.where(stripe_payout_id: p.id).empty?
          StripePayout.create(
            stripe_payout_id: p.id,
            amount: p.amount,
            stripe_created: p.created
          )
        end
        last_id = p.id
      end

      list = Stripe::Payout.list(limit: 100, starting_after: last_id)
    end
  end
end
