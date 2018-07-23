class LogsController < ApplicationController
  def create
    @log = Log.new(start_at: Time.now)

    if @log.save
      redirect_to edit_log_path(@log), notice: "Successfully started new log"
    else
      flash[:alert] = "Unable to start new log"
      redirect_back(fallback_location: dashboard_path)
    end
  end

  def edit
    @log = Log.find(params[:id])
  end

  def update
    @log = Log.find(params[:id])

    if update_log(@log)
      redirect_to dashboard_path, notice: "Successfully updated log"
    else
      render :edit
    end
  end

  def destroy
    @log = Log.find(params[:id])
    @log.destroy!

    redirect_to dashboard_path, notice: "Successfully deleted log"
  end

  private

    def log_params
      params.require(:log).permit(:project_id, :start_at, :end_at, :description)
    end

    def update_log(log)
      return false unless log.update_attributes(log_params)
      return true unless params[:commit] == "Finish Log"
      log.update_attributes(active: true)
    end
end
