class SavedFiltersController < ApplicationController
  def destroy
    filter = SavedFilter.find(params[:id])
    filter.destroy!
    flash.keep
    return redirect_to(url_for(controller: filter.controller, action: filter.action))
  end
end
