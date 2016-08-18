class ProjectsController < ApplicationController

  before_action :find_lab

  def options
    @projects = @lab.projects.order(:name)
  end

  protected

  def strong_params
    params.require(:project).permit(:name)
  end

  private

  def find_lab
    @lab = current_user.labs.find_by_slug!(params[:lab_id])
    save_lab_in_cookies(@lab)
  end

end
