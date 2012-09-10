$ ->
  $('.word').mouseover ->
    $(this).find('.known').css('color', 'black')
  .mouseout ->
    $(this).find('.known').css('color', '#dddddd')

  $('.known').click ->
    word = $(this).parent()
    id = word.find('.id').text().trim()
    $.post "/levels/known/#{id}", (data) ->
      word.css('background', '#ff9999')
      remove_word_entry = -> word.fadeOut('slow')
      setTimeout remove_word_entry, 100

