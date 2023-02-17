class TransactionsController < ApplicationController
   before_action :create_transaction_object, only: [:new, :new_large, :new_extra_large]
   before_action :set_transaction_manager, only: [:new, :new_extra_large]

  def index
    @transactions = Transaction.includes(:manager).order(id: :desc)
  end

  def show
    @transaction = Transaction.find(params[:id])
  end

  def new
    render "new_#{params[:type]}"
  end

  def new_large
  end

  def new_extra_large
  end

  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.save
      redirect_to @transaction
    else
      @manager = set_transaction_manager if params[:type] == 'extra'
      render "new_#{params[:type]}"
    end
  end

  private

  def set_transaction_manager
    @manager = Manager.all.sample
  end

  def create_transaction_object
    @transaction = Transaction.new
  end

  def transaction_params
    params.require(:transaction).permit(
      :first_name,
      :from_amount,
      :from_currency,
      :last_name,
      :manager_id,
      :to_currency
    )
  end
end
