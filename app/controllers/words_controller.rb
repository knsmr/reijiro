class WordsController < ApplicationController
  def index
    @words = Word.limit(50)
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

  def search
    query = params[:query]
    if @word = Word.find_or_lookup(query)
      render 'show'
    else
      render text: "Couldn't find #{query}.", layout: true
    end
  end
end
