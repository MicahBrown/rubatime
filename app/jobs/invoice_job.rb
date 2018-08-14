class InvoiceJob < ApplicationJob
  queue_as :default

  def perform(invoice)
    return if invoice.enqueued?
    invoice.update_attributes!(status: :enqueued)
    invoice.process!
  end
end
