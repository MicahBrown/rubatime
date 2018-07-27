class SessionsController < ApplicationController
  skip_before_action :authenticate

  def new
  end

  def create
    ENV['PASSWORD'] ||= "password" unless Rails.env.production?
    raise StandardError unless ENV['PASSWORD'].present?

    if ENV['PASSWORD'] == params[:password]
      login!
      redirect_to dashboard_path, notice: "Logged in!"
    else
      flash[:alert] = "Invalid password"
      render :new
    end
  end

  def destroy
    logout!
    redirect_to login_path, notice: "Logged out!"
  end
end
