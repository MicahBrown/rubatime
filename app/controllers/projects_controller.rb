class ProjectsController < ApplicationController
  def index
    @projects = Project.order("name ASC")
  end

  def new
  end

  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to projects_path, notice: "Successfully created new project!" }
      else
        format.html { render :new }
      end
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to projects_path, notice: "Successfully updated project!" }
      else
        format.html { render :edit }
      end
    end
  end

  private

    def project_params
      params.require(:project).permit(:name, :short_name, :archived, :client_id)
    end
end
