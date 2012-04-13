class ClipsController < ApplicationController
  # 1 /clips
  # GET /clips.json
  def index
    @words = Word.joins(:clip).where('status != 8').order('updated_at DESC').limit(50)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clips }
    end
  end

  def next
    # TODO create status table
    (0..7).each do |status|
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

  # GET /stats/
  # GET /stats.json
  def stats
    @stats = {}
    (1..12).each do |l|
      undone = Clip.level(l).undone.count
      done   = Clip.level(l).done.count
      total  = Level.where(level: l).count
      remain = total - (undone + done)
      @stats[l] = {undone: undone, done: done, total: total, remain: remain}
    end
    @stats['0'] = {undone: Clip.level(0).count, done: Clip.level(0).done.count}
    @stats['total'] = {
      undone: Clip.undone.count,
      done: Clip.done.count,
      ramin: Level.count - Clip.count,
      total: Level.count }

    respond_to do |format|
      format.html
      format.json { render json: @stats }
    end
  end
end
