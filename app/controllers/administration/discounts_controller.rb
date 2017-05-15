module Administration
  class DiscountsController < Administration::ApplicationController
    protected

    def order
      Administrate::Order.new(params[:order] || :name,
                              params[:direction] || :asc)
    end
  end
end
