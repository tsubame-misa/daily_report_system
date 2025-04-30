class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @report = Report.find(params[:report_id])
    @favorite = current_user.favorites.build(report: @report)

    if @favorite.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "favorite-button-#{@report.id}",
            partial: 'reports/favorite',
            locals: { report: @report, favorite: @favorite }
          )
        end
        format.html { redirect_to request.referer }
      end
    else
      redirect_to request.referer
    end
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    @report = @favorite.report

    @favorite.destroy
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "favorite-button-#{@report.id}",
          partial: 'reports/favorite',
          locals: { report: @report, favorite: nil }
        )
      end
      format.html { redirect_to request.referer }
    end
  end
end
