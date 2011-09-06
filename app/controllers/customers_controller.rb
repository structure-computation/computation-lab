class CustomersController < InheritedResources::Base
    layout 'workspace'

    def create
      @new_customer = Customer.create(params[:customer])
      @new_customer.init_account
      render :json => { :result => 'success' }
    end  


  end
