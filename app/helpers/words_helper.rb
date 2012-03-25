# -*- coding: utf-8 -*-
module WordsHelper
  def status_button(duration, status)
    link_to duration, clip_path(@word.clip, clip: {status: status}), class: 'btn', id: "status#{status}", method: :put, remote: true, data: {type: :json}
  end

  def preprocess(word)
    entry = word.entry
    body = word.definition
    items = ""; underlined = ""

    body.each_line do |line|
      line.gsub!(entry, "<strong class='highlight'>" + entry + "</strong>")
      case line
      when /^(■.*)$/
        items << "<p>#{$1}</p>\n"
      when /^@(■.*)$/
        underlined << "<p><span class='underscore'>#{$1}</span></p>\n"
      end
    end
    underlined + items
  end
end
