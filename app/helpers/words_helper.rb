module WordsHelper
  def status_button(duration, status)
    link_to duration, clip_path(@word.clip, clip: {status: status}), class: 'btn', id: "status#{status}", method: :put, remote: true, data: {type: :json}
  end
end
