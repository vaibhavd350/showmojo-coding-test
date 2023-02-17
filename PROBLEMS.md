### Described found weak places below here.

#### Performance issues

1. That is best if we assign the managers manually on large transactions using admin dashboard. using we can improves the performance. also if we use this then avoid the many get manager qeury in create and other action action.

2. We should use include method for the N+1 problem in 'views/transactions/index.html.erb'. When display a each transaction, there is a SQL query required to get manager. we should use eager loading in 'TransactionsController#index' loading to fix (with 'includes(:manager)')

3. 'TransactionsController#index' if we have multiples of transactions, it will kill the memory. We should paginate transaction before showing the list.

4.  'TransactionsController#new' : '@manager = Manager.all.sample' => This line will load all managers in database and onto memory then pick a sample(random). It's very bad if we have large amount of managers in database.


#### Security issues

1. TransactionsController#create should be used the strong parameters. and we can also safe the unwanted parameters. we should not use 'permit!' because this is 'permit' the unsafe parameters.

2. No authication found, We should use any authication gem like device, also use the cancancan and pandit gems for the actions policy and authication, based on roles, and rolify use for the roles base access.  

3. Should be set all ENV keys in environment variables


#### Code issues

1.TransactionsController#new' We should use client side validation.

2. May the these method 'full_name' and 'client_full_name' in Manager model can be refactored using Decorator or  Helper, it's just for displaying purpose so we might not want it to be inside the model.

3. We should the used the callbacks for the handle repeated code.

4. In the transaction show page code for rendering error in views is quite duplicated, refactoring into a helper method 

#### Others

1. We need the add error message code in the UI because errror message code is messing in UI.

2. We can use loop for the transaction links list bacause we have repeart the link code on TransactionsController#show page. 

3. Curently no error is showing for Transaction, when user create small transaction with amount > 100 USD. 

