class InvoicesController < ApplicationController
  before_action :require_login
  before_action :set_invoice, only: %i[ show edit update destroy ]

  # GET /invoices or /invoices.json
  def index
    @invoices = Invoice.all
  end

  # GET /invoices/1 or /invoices/1.json
  def show
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
  end

  # GET /invoices/1/edit
  def edit
  end

  # POST /invoices or /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)

    respond_to do |format|
      if @invoice.save
        check_low_stock_levels(@invoice)
        format.html { redirect_to invoices_url, notice: "Invoice was successfully created." }
        format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoices/1 or /invoices/1.json
  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        check_low_stock_levels(@invoice)
        format.html { redirect_to invoices_url, notice: "Invoice was successfully updated." }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1 or /invoices/1.json
  def destroy
    @invoice.destroy!

    respond_to do |format|
      format.html { redirect_to invoices_path, status: :see_other, notice: "Invoice was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    def check_low_stock_levels(invoice)
      low_stock_warnings = invoice.invoice_items.filter_map do |item|
        item.low_stock_message if item.low_stock?
      end

      if low_stock_warnings.any?
        flash[:warning] = low_stock_warnings.join("<br>").html_safe
      end
    end

    # Only allow a list of trusted parameters through.
    def invoice_params
      params.require(:invoice).permit(
        :customer_name,
        :customer_email,
        :status,
        :discount,
        :total_amount,
        invoice_items_attributes: [:id, :product_id, :quantity, :_destroy]
      )
    end
end
