class HomeController < ApplicationController
  skip_before_action :authenticate

  def index
    if signed_in?
      redirect_to dashboard_path
    else
      redirect_to login_path
    end
  end
end
