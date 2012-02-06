class WordsController < ApplicationController
  def index
    @words = Word.all
    respond_to do |format|
      format.html
      format.json { render json: @words }
    end
  end

  def show
    @word = Word.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @word }
    end
  end
end
