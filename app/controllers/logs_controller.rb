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

    respond_to do |format|
      if update_log(@log)
        format.html { redirect_to dashboard_path, notice: "Successfully updated log" }
      else
        format.js
      end
    end
  end

  def destroy
    @log = Log.find(params[:id])
    @log.destroy!

    redirect_to dashboard_path, notice: "Successfully deleted log"
  end

  private

    def log_params
      params.require(:log).permit(:project_id, :description, start_at: [:date, :time], end_at: [:date, :time])
    end

    def update_log(log)
      return false unless log.update(log_params)
      return true unless params[:commit] == "Finish Log"
      log.update(active: true)
    end
end
