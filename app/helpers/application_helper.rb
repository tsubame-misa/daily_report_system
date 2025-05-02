module ApplicationHelper
  def sort_arrow(column)
    if params[:sort] == column
      direction = params[:direction] == "asc" ? "desc" : "asc"
      arrow = params[:direction] == "asc" ? "↑" : "↓"
    else
      direction = "asc"
      arrow = "↓"
    end
    base_params = request.query_parameters.merge(sort: column, direction: direction)
    link_to arrow, url_for(base_params), class: "btn btn-sm btn-outline-secondary"
  end
  def render_filter(path:)
    render partial: 'layouts/filter', locals: { filter_path: path }
  end
  def render_search_bar(path:, placeholder: nil)
    render partial: 'share/search_bar', locals: { search_path: path, placeholder: placeholder }
  end
  def hidden_fields_except(*except_keys)
    request.query_parameters.except(*except_keys).map do |key, value|
      hidden_field_tag key, value
    end.join.html_safe
  end

end
