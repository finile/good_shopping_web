class Payment < ApplicationRecord
  belongs_to :order

  def deadline
    Date.today + 3.days
  end

  PAYMENT_METHODS = %w(Credit WebATM ATM)
  validates_inclusion_of :payment_method, in: PAYMENT_METHODS

end
