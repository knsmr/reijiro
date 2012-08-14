class LevelsController < ApplicationController
  def index
    @to_import = []
    (1..12).each do |l|
      @to_import[l] = Level.yet_to_import(l, 5)
    end
  end

  def show
    @words =
      Level.where(level: params[:id])
      .where("word NOT IN (?)", Word.imported_list)
  end
end
