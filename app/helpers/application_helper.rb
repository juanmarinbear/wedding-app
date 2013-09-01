module ApplicationHelper

  def get_admin
    unless current_admin?
      redirect_to root_path
    end
  end
  
end
