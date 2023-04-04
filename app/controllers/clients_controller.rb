class ClientsController < ApplicationController
  def index
    @clients = Client.order("name ASC")
  end

  def new
  end

  def create
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        format.html { redirect_to clients_path, notice: "Successfully created new client!" }
      else
        format.html { render :new }
      end
    end
  end

  def edit
    @client = Client.find(params[:id])
  end

  def update
    @client = Client.find(params[:id])

    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to clients_path, notice: "Successfully updated client!" }
      else
        format.html { render :edit }
      end
    end
  end

  private

    def client_params
      params.require(:client).permit(:name, :archived)
    end
end
