class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @report = Report.find(params[:report_id])
    @favorite = current_user.favorites.build(report: @report)

    if @favorite.save
      # HACK: 全体再読み込みではなく、1レポート、もしくはお気に入りボタンのみ再読込したい
      # render turbo_stream: turbo_stream.replace(
      #   'favorite-button-' + @report.id,
      #   partial: 'reports/favorite',
      #   locals: { report: @report, favorite: @favorite },
      # )
      redirect_to request.referer
    else
      redirect_to request.referer
    end
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    @report = @favorite.report

    @favorite.destroy
    # render turbo_stream: turbo_stream.replace(
    #   'favorite-button-' + @report.id,
    #   partial: 'reports/favorite',
    #   locals: { report: @report, favorite: @favorite },
    # )
    redirect_to request.referer
  end
end
