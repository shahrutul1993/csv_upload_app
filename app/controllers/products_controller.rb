class ProductsController < ApplicationController

  def index
   @products = Product.order(:id)
    respond_to do |format|
      format.html
      format.csv { send_data @products.to_csv }
     
    end
  end

  def import
    Product.import(params[:file])
    redirect_to root_url, notice: "Products imported."
  end


  private
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :price)
    end
end
