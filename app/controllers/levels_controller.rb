class LevelsController < ApplicationController
  def index
    @words =
      Level.where(level: params[:level])
      .where("word NOT IN (?)", Word.pluck(:entry))
      .pluck(:word)
  end
end
