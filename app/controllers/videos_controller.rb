class VideosController < ApplicationController

  def index
    @media_type = [['TV or Movie', nil], ['TV show', 'tv'], ['Movie', 'movie']]
    @popularity = [['Popularity', nil], ['> 0', 0], ['> 5', 5], ['> 10', 10], ['> 20', 20], ['> 30', 30]]
    @genre_ids = [['Genre', nil], ['Drama', 18], ['Documentary', 99], ['Comedy', 35], ['Animation', 16], ['Romance', 10749], ['Crime',80]]

    @videos = Video.all
    # @videos = Video.all.sort_by { |e| e[:avg_vote] }.reverse

    # default popularity set to at least 10
    @videos = @videos.where('popularity > 10', params[:popularity]) unless params[:popularity].present?
    # @videos = @videos.where('genre_ids @> ARRAY[?]::integer[]', [18]) unless params[:genre_ids].present?
    # @videos = @videos.where(genre_ids: [18]) unless params[:genre_ids].present?

    @videos = @videos.where('media_type LIKE ?', params[:media_type]) if params[:media_type].present?
    @videos = @videos.where('popularity > ?', params[:popularity]) if params[:popularity].present?
    @videos = @videos.where('genre_ids @> ARRAY[?]::integer[]', params[:genre_ids]) if params[:genre_ids].present?
    # @videos = @videos.where('(?) IN genre_ids', params[:genre_ids]) if params[:genre_ids].present?
    # @videos = @videos.where('media_type LIKE ? AND popularity > ?', params[:media_type], params[:popularity]) if params[:media_type].present? && params[:popularity].present?

    # @spaces = @spaces.where('city LIKE ?', params[:city]) if params[:city].present?
    # @spaces = @spaces.where('category LIKE ?', params[:category]) if params[:category].present?
    # @spaces = @spaces.where('required_skill LIKE ?', params[:required_skill]) if params[:required_skill].present?
    # @spaces = @spaces.where('city LIKE ? AND required_skill LIKE ?', params[:city], params[:required_skill]) if params[:city].present? && params[:required_skill].present?
    # @spaces = @spaces.where('city LIKE ? AND category LIKE ?', params[:city], params[:category]) if params[:city].present? && params[:category].present?
    # @spaces = @spaces.where('category LIKE ? AND required_skill LIKE ?', params[:category], params[:required_skill]) if params[:category].present? && params[:required_skill].present?
    # @spaces = @spaces.where('city LIKE ? AND category LIKE ? AND required_skill LIKE ?', params[:city], params[:category], params[:required_skill]) if params[:city].present? && params[:category].present? && params[:required_skill].present?

  end

  def show
    @video = Video.find(params[:id])
  end

end
