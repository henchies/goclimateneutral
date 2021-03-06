# frozen_string_literal: true

class GiftCardReceiptsController < ApplicationController
  def show
    @receipt = GiftCardReceiptPdf.new(GiftCard.find_by_key!(params[:key]))
    send_data @receipt.render, filename: 'receipt.pdf', type: :pdf
  end
end
