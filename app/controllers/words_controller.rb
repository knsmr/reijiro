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

  def edit
    @word = Word.find(params[:id])
  end

  def update
    @word = Word.find(params[:id])

    respond_to do |format|
      if @word.update_attributes(params[:word])
        format.html { redirect_to @word, notice: 'Word was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @word = Word.find(params[:id])
    @word.destroy

    respond_to do |format|
      format.html { redirect_to words_url }
      format.json { head :no_content }
    end
  end

  def search
    query = params[:query].downcase.chomp
    if @word = Word.where(entry: query).first
      flash.now[:success] = "Already clipped!"
      render 'show'
    elsif @word = Word.search(query)
      flash.now[:success] = "Found and clipped!"
      render 'show'
    else
      render text: "Couldn't find #{query}.", layout: true
    end
  end

  def import
  end

  def import_from_alc12000
    # We want to make sure there's at least one clip available right
    # after this action. Wait for one word to process but don't wait
    # for the rest.
    @words = []
    if word = Level.yet_to_import(params[:level], 1).first
      @words << Word.search(word)
    else
      render text: "No more level #{params[:level]} words to import.", layout: true
    end

    # Let got the browser immediately since this action is a bit too
    # time-consuming. EventMachine rocks!
    if words = Level.yet_to_import(params[:level], 4)
      EM.defer do
        words.each do |word|
          @words << Word.search(word)
        end
      end
      redirect_to root_path, notice: "Importing 4 more words from level#{params[:level]} in the background."
    else
      render text: "No more level #{params[:level]} words to import.", layout: true
    end
  end
end
