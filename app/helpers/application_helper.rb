module ApplicationHelper
  def sort_arrow(column)
    if params[:sort] == column
      direction = params[:direction] == "asc" ? "desc" : "asc"
      arrow = params[:direction] == "asc" ? "↑" : "↓"
    else
      direction = "asc"
      arrow = "↓"
    end

    if current_user.admin?
      link_to arrow, admin_reports_path(sort: column, direction: direction), class: "btn btn-sm btn-outline-secondary"
    else
      link_to arrow, reports_path(sort: column, direction: direction), class: "btn btn-sm btn-outline-secondary"
    end
  end
end

