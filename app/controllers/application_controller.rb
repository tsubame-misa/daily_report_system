class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def not_found
    render 'errors/not_found', status: :not_found, locals: { hide_sub_header: true }
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name role])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name role])
  end

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_calendar_month_path
    else
      calendar_month_path
    end
  end
end
