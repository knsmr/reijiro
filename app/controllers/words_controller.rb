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

  def stats
  end

  def search
    query = params[:query]
    if @word = Word.find_or_lookup(query)
      flash.now[:success] = "Found and clipped!"
      render 'show'
    else
      render text: "Couldn't find #{query}.", layout: true
    end
  end

  def import_from_alc12000
    # TODO: This is slow. Should I have used raw SQL instead?
    @words = []
    if words = Level.yet_to_import(params[:level])
      words.each do |word|
        @words << Word.find_or_lookup(word)
      end
      flash.now[:success] = "Imported 10 words below from level#{params[:level]}."
      render 'index'
    else
      render text: "No more level #{level} words to import.", layout: true
    end
  end
end
