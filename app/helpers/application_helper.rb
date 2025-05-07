module ApplicationHelper
  def sort_arrow(column)
    if params[:sort] == column
      direction = params[:direction] == "asc" ? "desc" : "asc"
      arrow = params[:direction] == "asc" ? "▲" : "▼"
    else
      direction = "asc"
      arrow = "▼"
    end
    base_params = request.query_parameters.merge(sort: column, direction: direction)
    link_to arrow, url_for(base_params), class: "btn btn-sm arrow-button"
  end

  def favorite_filter_link
    base_params = request.query_parameters
    is_favorite = params[:favorite_only] == "true"

    base_params = if is_favorite
                    base_params.except(:favorite_only)
    else
      base_params = base_params.merge(favorite_only: "true")
    end

    link_to url_for(base_params), class: 'd-flex align-items-center text-decoration-none favorite-only-toggle' do
      content_tag(:div, class: 'd-flex align-items-center gap-2') do
        content_tag(:div, class: 'form-check form-switch') do
          content_tag(:input, '', type: 'checkbox', class: 'form-check-input form-switch-lg', checked: is_favorite) +
            content_tag(:div, class: 'd-flex align-items-center') do
              content_tag(:span, 'いいねのみ表示', class: 'text-dark')
            end
        end
      end
    end
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
