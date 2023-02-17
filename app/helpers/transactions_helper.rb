module TransactionsHelper
  def full_name(transaction)
    "#{transaction&.first_name} #{transaction&.last_name}"
  end
end
