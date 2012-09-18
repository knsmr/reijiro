class WordsController < ApplicationController
  before_filter :load_word, only: [:show, :edit, :update, :destroy]

  def index
    @words = Word.limit(50)
    respond_to do |format|
      format.html
      format.json { render json: @words }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @word }
    end
  end

  def create
    @word = Word.new(params[:word])

    respond_to do |format|
      if @word.save
        @word.create_clip(status: 0)
        format.html { redirect_to @word, notice: 'Clip was successfully created.' }
        format.json { render json: @word, status: :created, location: @word }
      else
        format.html { render action: "search" }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
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
    @word.destroy

    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Deleted a word.' }
      format.json { head :no_content }
    end
  end

  def search
    @query = params[:query].downcase.chomp
    if @word = Word.where(entry: @query).first
      flash.now[:success] = "Already clipped!"
      render 'show'
    elsif @word = Word.search(@query)
      flash.now[:success] = "Found and clipped!"
      render 'show'
    end
    @word = Word.new(entry: @query)
  end

  def import
    @words = []
    new_words = params.select {|k, v| v == "1"}.keys
    new_words.each do |w|
      @words << Word.search(w)
    end
    flash[:notice] = "Imported #{@words.count} words."
    render "words/import"
  end

  def async_import
    @query = params[:word].downcase.chomp
    unless Word.where(entry: @query).first
      EM.defer do
        @word = Word.search(@query)
      end
      render nothing: true
    end
  end

private

  def load_word; @word = Word.find(params[:id]); end
end
