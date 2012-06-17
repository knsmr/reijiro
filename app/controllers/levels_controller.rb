class LevelsController < ApplicationController
  def index
  end

  def show
    @words =
      Level.where(level: params[:id])
      .where("word NOT IN (?)", Word.pluck(:entry))
      .pluck(:word)
  end
end
