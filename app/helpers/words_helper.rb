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
    body = process_body(word.definition, entry)

    definitions = ""; items = ""; underlined = ""

    body.each_line do |line|
      case line
      when /^([^@].*{([^}]+)} : .+)$/
        category, content = $2, $1
        if category =~ proper_nouns
          items << "<p>#{content}</p>\n"
        else
          definitions << "<p class='word-definition'>#{content}</p>\n"
        end
      when /^(■.*)$/
        items << "<p>#{$1}</p>\n"
      when /^@(.*)$/
        underlined << "<p class='underscore'>#{$1}</p>\n"
      when /^(.*)$/
        items << "<p>#{$1}</p>\n"
      end
    end

    underlined + definitions + items
  end

private

  def process_body(body, entry)
    body = split_example_sentence(body)
    body = remove_yomigana(body)
    body.gsub(entry, "<strong class='highlight'>" + entry + "</strong>")
  end

  def remove_yomigana(str)
    str.gsub(/｛[^｝]+｝/, '')
  end

  def split_example_sentence(str)
    str.gsub(/■・(.*)$/, "\n■\\1")
  end

  def proper_nouns
    @proper_nouns ||= Regexp.new('組織|商標|著作|映画|小説|雑誌名|新聞名|地名|人名|曲名|バンド名|チーム名|アルバム名')
  end
end
