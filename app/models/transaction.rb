class Transaction < ApplicationRecord
  AVAILABLE_CURRENCIES = ['USD', 'GBP', 'AUD', 'CAD'].freeze

  belongs_to :manager, optional: true

  monetize :from_amount_cents, with_currency: ->(t) { t.from_currency }, numericality: { greater_than: 0 }
  monetize :to_amount_cents, with_currency: ->(t) { t.to_currency }

  validates :first_name, presence: true, if: :large?
  validates :last_name, presence: true, if: :large?
  validates :from_currency, inclusion: AVAILABLE_CURRENCIES
  validates :to_currency, inclusion: AVAILABLE_CURRENCIES
  validate :currencies_validation
  validate :manager_validation

  before_create :generate_uid
  before_validation :convert
  
  def large?
    from_amount_in_usd > Money.from_amount(100)
  end

  def extra_large?
    from_amount_in_usd > Money.from_amount(1000)
  end

  def from_amount_in_usd
    from_amount.exchange_to('USD')
  end

  private

  def generate_uid
    self.uid = SecureRandom.hex(5)
  end

  def convert
    if self.to_amount.blank?
      self.to_amount = from_amount.exchange_to(self.to_currency)
    end
  end

  def currencies_validation
    if from_currency == to_currency
      errors.add(:from_currency, "can't be converted to the same currency.")
    end
    if !extra_large? && from_currency != 'USD'
      errors.add(:from_currency, "available only for conversions over $1000.")
    end
  end

  def manager_validation
    if extra_large? && !manager
      errors.add(:base, "conversions over $1000 require personal manager.")
    end
  end
end
