class VideosController < ApplicationController

  def index
    @videos = Video.all
    # @videos = Video.all.sort_by { |e| e[:avg_vote] }.reverse
  end

  def show
    @video = Video.find(params[:id])
  end

end
