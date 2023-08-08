class ApplicationController < ActionController::Base
  before_action :authenticate

  def signed_in?
    auth_cookie == true
  end
  helper_method :signed_in?

  def auth_cookie
    session[:auth]
  end

  def login!
    session[:auth] = true
  end

  def logout!
    session[:auth] = nil
  end

  def current_log
    @current_log ||= Log.where(active: false).first
  end
  helper_method :current_log

  private

    def authenticate
      redirect_to(login_path, alert: "You must be logged in") unless signed_in?
    end

    def load_and_save_filters
      @filter = SavedFilter.find_or_initialize_by(action: params[:action], controller: params[:controller])

      if request.query_parameters.present?
        @filter.filters = request.query_parameters
        @filter.save!
      elsif @filter.filters.present?
        return redirect_to(url_for(@filter.filters))
      end
    end
end
