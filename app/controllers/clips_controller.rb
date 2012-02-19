class ClipsController < ApplicationController
  # 1 /clips
  # GET /clips.json
  def index
    @words = Word.joins(:clip).order('updated_at DESC').limit(50)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clips }
    end
  end

  # GET /clips/1
  # GET /clips/1.json
  def show
    @clip = Clip.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @clip }
    end
  end

  def picknew
    if params[:level]
      @word = Word.unclipped.where(level: params[:level]).first
    else
      @word = Word.unclipped.first
    end
    render 'words/show'
  end

  def nextup
    # TODO: clean this up
    @clips = (1..7).map do |status|
      Clip.overdue(status)
    end.flatten!
    @words = @clips.map(&:word)
    render 'index'
  end

  def next
    # TODO create status table
    (1..7).each do |status|
      @clip = Clip.overdue(status).first
      break unless @clip.blank?
    end

    if @clip
      @word = @clip.word
      render template: 'words/show'
    else
      render text: "Yey! No items.", layout: true
    end
  end

  # GET /clips/new
  # GET /clips/new.json
  def new
    @clip = Clip.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @clip }
    end
  end

  # GET /clips/1/edit
  def edit
    @clip = Clip.find(params[:id])
  end

  # POST /clips
  # POST /clips.json
  def create
    @clip = Clip.new(params[:clip])

    if @clip.save
      redirect_to word_path(@clip.word) , flash: {notice: "added #{@clip.word.entry}"}
    else
      redirect_to word_path(@clip.word), flash: {error: "Error"}
    end
  end

  # PUT /clips/1
  # PUT /clips/1.json
  def update
    @clip = Clip.find(params[:id])
    @clip.touch # touch the record, even if there's no change

    respond_to do |format|
      if @clip.update_attributes(params[:clip])
        format.html { redirect_to @clip, notice: 'Clip was successfully updated.' }
        format.json { render json: @clip }
      else
        format.html { render action: "edit" }
        format.json { render json: @clip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clips/1
  # DELETE /clips/1.json
  def destroy
    @clip = Clip.find(params[:id])
    @clip.destroy

    respond_to do |format|
      format.html { redirect_to clips_url }
      format.json { head :no_content }
    end
  end
end
