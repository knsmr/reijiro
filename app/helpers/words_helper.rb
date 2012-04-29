# -*- coding: utf-8 -*-
module WordsHelper
  def status_button(duration, status)
    link_to duration, clip_path(@word.clip, clip: {status: status}), class: 'btn', id: "status#{status}", method: :put, remote: true, data: {type: :json}
  end

  def link_to_google(str, query)
    link_to str, "https://www.google.com/search?hl=en&q=#{query}", target: '_blank'
  end

  def preprocess(word)
    entry = word.entry
    body = word.definition
    items = ""; underlined = ""

    body.each_line do |line|
      line.gsub!(entry, "<strong class='highlight'>" + entry + "</strong>")
      line = remove_yomigana(line)

      case line
      when /^(■.*)$/
        items << "<p>#{$1}</p>\n"
      when /^@(■.*)$/
        underlined << "<p><span class='underscore'>#{$1}</span></p>\n"
      end
    end
    underlined + items
  end

  def remove_yomigana(str)
    # ■akin {形} : 血族｛けつぞく｝の、同族｛どうぞく｝の、同種｛どうしゅ｝の
    # → ■akin {形} : 血族の、同族の、同種の
    str.gsub(/｛[^｝]+｝/, '')
  end
end
