class LevelsController < ApplicationController
  def index
    @to_import = []
    (1..12).each do |l|
      @to_import[l] = Level.yet_to_import(l, 5)
    end
  end

  def show
    @words =
      Level.unknown
      .where(level: params[:level])
      .where("word NOT IN (?)", Word.imported_list)
  end

  def known
    l = Level.where(id: params[:id]).first
    l.update_column(:known, true)
    render text: params[:id]
  end
end
